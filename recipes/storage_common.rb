# Add default repos for Bareos Packages
include_recipe 'bareos::package_repos_common'

package 'bareos-storage'

directory '/etc/bareos/bareos-sd.d' do
  path '/etc/bareos/bareos-sd.d'
  owner 'bareos'
  group 'bareos'
  mode '0750'
  action :create
end

%w(
  autochanger
  device
  director
  messages
  ndmp
  storage
).each do |path_name|
  directory "storage_#{path_name}_dir" do
    path "/etc/bareos/bareos-sd.d/#{path_name}"
    owner 'bareos'
    group 'bareos'
    mode '0750'
    action :create
  end
end

# Start and enable Bareos Storage Daemon service
service 'bareos-sd' do
  supports [status: true, restart: true, reload: false]
  action [:enable, :start]
  ignore_failure true
end
