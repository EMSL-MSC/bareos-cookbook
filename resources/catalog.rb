
property :catalog_config, Hash, default: {
  dbname: 'bareos',
  dbuser: 'bareos',
  dbpassword: '',
}
property :catalog_backend, String, equal_to: %w(postgresql mysql), default: 'postgresql'
property :template_name, String, default: 'catalog.erb'
property :template_cookbook, String, default: 'bareos'

default_action :create

action :create do
  # I am only inlcuding the bareos-director package here because it is a
  # dependency of "bareos-dbcheck" which is called from the database scripts.
  # This ideally shouldn't be the case but..it is.. So just in case, installing.
  package %w(
    bareos-director
    bareos-database-common
    bareos-database-tools
  )

  case new_resource.catalog_backend
  when 'mysql'
    package 'bareos-database-mysql'
    script_prefix = ''
  else
    package 'bareos-database-postgresql'
    script_prefix = 'su postgres -s /bin/bash -c '
  end

  template "director_catalog_#{new_resource.name}" do
    path "/etc/bareos/bareos-dir.d/catalog/#{new_resource.name}.conf"
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      catalog_name: new_resource.name,
      catalog_backend: new_resource.catalog_backend,
      catalog_config: new_resource.catalog_config
    )
    action :create
  end

  group 'bareos' do
    action :modify
    members %w(bareos postgres)
    append true
    only_if { new_resource.catalog_backend == 'postgresql' }
  end

  bash "create_bareos_database_#{new_resource.name}" do
    code <<-DBCREATED
#!/bin/bash
set -e
#{script_prefix}/usr/lib/bareos/scripts/create_bareos_database
RESULT=$?
if [ $RESULT -eq 0 ]; then
  su bareos -s /bin/bash -c "touch /var/lib/bareos/.dbcreated_#{new_resource.name}"
fi
DBCREATED
    creates "/var/lib/bareos/.dbcreated_#{new_resource.name}"
    action :run
  end

  bash "make_bareos_tables_#{new_resource.name}" do
    code <<-TABCREATED
#!/bin/bash
set -e
#{script_prefix}/usr/lib/bareos/scripts/make_bareos_tables
RESULT=$?
if [ $RESULT -eq 0 ]; then
  su bareos -s /bin/bash -c "touch /var/lib/bareos/.dbtabcreated_#{new_resource.name}"
fi
TABCREATED
    creates "/var/lib/bareos/.dbtabcreated_#{new_resource.name}"
    action :run
  end

  bash "update_bareos_tables_#{new_resource.name}" do
    code <<-TABUPDATED
#!/bin/bash
set -e
if [ -f /var/lib/bareos/.dbprivgranted_#{new_resource.name} ]; then
  rm -f /var/lib/bareos/.dbprivgranted_#{new_resource.name}
fi
#{script_prefix}/usr/lib/bareos/scripts/update_bareos_tables
RESULT=$?
if [ $RESULT -eq 0 ]; then
  su bareos -s /bin/bash -c "touch /var/lib/bareos/.dbtabupdated_#{new_resource.name}"
fi
TABUPDATED
    creates "/var/lib/bareos/.dbtabupdated_#{new_resource.name}"
    action :run
  end

  bash "grant_bareos_privileges_#{new_resource.name}" do
    code <<-PRIVGRANTED
#!/bin/bash
set -e
#{script_prefix}/usr/lib/bareos/scripts/grant_bareos_privileges
RESULT=$?
if [ $RESULT -eq 0 ]; then
  su bareos -s /bin/bash -c "touch /var/lib/bareos/.dbprivgranted_#{new_resource.name}"
fi
PRIVGRANTED
    creates "/var/lib/bareos/.dbprivgranted_#{new_resource.name}"
    action :run
  end
end
