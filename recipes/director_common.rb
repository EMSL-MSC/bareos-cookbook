# Add default repos for Bareos Packages
include_recipe 'bareos::package_repos_common'

# Do the common things for all catalogs, shouldn't affect multiple cases
# create the dbconfig-common if missing
directory '/etc/dbconfig-common'

# prevent auto db init on debian systems
template 'dbconfig-common-bareos-database-common' do
  source 'bareos-database-common.erb'
  path '/etc/dbconfig-common/bareos-database-common.conf'
  owner 'root'
  group 'root'
  mode '0600'
end

# managing this in case someone would like to overwrite it for debian systems
template 'dbconfig-common-config' do
  source 'bareos-database-config.erb'
  path '/etc/dbconfig-common/config'
  owner 'root'
  group 'root'
  mode '0600'
end

# Install base set of database tools to create a catalog
package %w(bareos-database-tools bareos-database-common)

package 'bareos-director'

directory '/etc/bareos/bareos-dir.d' do
  path '/etc/bareos/bareos-dir.d'
  owner 'bareos'
  group 'bareos'
  mode '0750'
  action :create
end

%w(
  catalog
  client
  console
  counter
  director
  fileset
  job
  jobdefs
  messages
  pool
  profile
  schedule
  storage
).each do |path_name|
  directory "director_#{path_name}_dir" do
    path "/etc/bareos/bareos-dir.d/#{path_name}"
    owner 'bareos'
    group 'bareos'
    mode '0750'
    action :create
  end
end

# Deploy the single default Bareos Catalog
bareos_director_catalog 'MyCatalog' do
  catalog_config(
    'dbname' => 'bareos',
    'dbuser' => 'bareos',
    'dbpassword' => ''
  )
  catalog_backend 'postgresql'
  template_name 'director_catalog.erb'
  template_cookbook 'bareos'
  action :create
end

# Start and enable Bareos Director service
service 'bareos-dir' do
  supports [status: true, restart: true, reload: false]
  action [:enable, :start]
  ignore_failure true
end
