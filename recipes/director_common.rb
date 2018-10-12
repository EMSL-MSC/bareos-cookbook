include_recipe 'bareos::package_repos_common'
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

default_catalog_config = {
  'dbname' => 'bareos',
  'dbuser' => 'bareos',
  'dbpassword' => '',
}
bareos_catalog 'MyCatalog' do
  catalog_config default_catalog_config
  not_if { node['bareos']['unmanage_default_catalog'] }
end

# Start and enable SD service
service 'bareos-dir' do
  supports [status: true, restart: true, reload: false]
  action [:enable, :start]
end
