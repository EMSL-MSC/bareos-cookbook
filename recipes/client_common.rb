# Add default repos for Bareos Packages
include_recipe 'bareos::package_repos_common'

package 'bareos-filedaemon'

directory '/etc/bareos/bareos-fd.d' do
  path '/etc/bareos/bareos-fd.d'
  owner 'root'
  group 'bareos'
  mode '0750'
  action :create
end

%w(
  client
  director
  messages
).each do |path_name|
  directory "client_#{path_name}_dir" do
    path "/etc/bareos/bareos-fd.d/#{path_name}"
    owner 'root'
    group 'bareos'
    mode '0750'
    action :create
  end
end

# Start and enable Bareos Filedaemon service
service 'bareos-fd' do
  supports [status: true, restart: true, reload: false]
  action [:enable, :start]
  ignore_failure true
end
