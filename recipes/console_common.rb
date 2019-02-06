# Add default repos for Bareos Packages
include_recipe 'bareos::package_repos_common'

package 'bareos-bconsole'

directory 'Bareos Console Dir' do
  path '/etc/bareos'
  owner 'root'
  group 'bareos'
  mode '0755'
  action :create
end
