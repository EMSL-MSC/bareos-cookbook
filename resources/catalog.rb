property :catalog_config, Hash, required: true
property :catalog_backend, String, equal_to: %w(postgresql mysql), default: 'postgresql'
property :template_name, String, default: 'catalog.erb'
property :template_cookbook, String, default: 'bareos'

action :create do
  package 'bareos-database-common'
  package 'bareos-database-postgresql' if new_resource.catalog_backend == 'postgresql'
  package 'bareos-database-mysql' if new_resource.catalog_backend == 'mysql'

  template "director_catalog_#{new_resource.name}" do
    source new_resource.template_name
    path "/etc/bareos/bareos-dir.d/catalog/#{new_resource.name}.conf"
    cookbook new_resource.template_cookbook
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      catalog_config: new_resource.catalog_config,
      catalog_name: new_resource.name,
      catalog_backend: new_resource.catalog_backend
    )
    action :create
  end

  script_prefix = if new_resource.catalog_backend == 'postgresql'
                    'su postgres -s /bin/bash -c '
                  else
                    ''
                  end

  group 'bareos' do
    action :modify
    members %w(bareos postgres)
    append true
    only_if { new_resource.catalog_backend == 'postgresql' }
  end

  execute "create_bareos_database_#{new_resource.name}" do
    command <<-DBCREATED
#{script_prefix}/usr/lib/bareos/scripts/create_bareos_database && \
touch /var/lib/bareos/.dbcreated_#{new_resource.name}
DBCREATED
    creates "/var/lib/bareos/.dbcreated_#{new_resource.name}"
    action :run
  end

  execute "make_bareos_tables_#{new_resource.name}" do
    command <<-TABCREATED
#{script_prefix}/usr/lib/bareos/scripts/make_bareos_tables && \
touch /var/lib/bareos/.dbtabcreated_#{new_resource.name}
TABCREATED
    creates "/var/lib/bareos/.dbtabcreated_#{new_resource.name}"
    action :run
  end

  execute "update_bareos_tables_#{new_resource.name}" do
    command <<-TABUPDATED
rm -f /var/lib/bareos/.dbprivgranted_#{new_resource.name}
#{script_prefix}/usr/lib/bareos/scripts/update_bareos_tables && \
touch /var/lib/bareos/.dbtabupdated_#{new_resource.name}
TABUPDATED
    creates "/var/lib/bareos/.dbtabupdated_#{new_resource.name}"
    action :run
  end

  execute "grant_bareos_privileges_#{new_resource.name}" do
    command <<-PRIVGRANTED
#{script_prefix}/usr/lib/bareos/scripts/grant_bareos_privileges && \
touch /var/lib/bareos/.dbprivgranted_#{new_resource.name}
PRIVGRANTED
    creates "/var/lib/bareos/.dbprivgranted_#{new_resource.name}"
    action :run
  end
end
