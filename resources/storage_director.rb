# Deploys and manages a single Bareos Storage Director Config

property :director_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_daemon_director.erb'

action :create do
  include_recipe 'bareos::storage_daemon_common'

  template "storage_#{new_resource.name}_director_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-sd.d/director/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      director_config: new_resource.director_config,
      director_name: new_resource.name
    )
    notifies :restart, 'service[bareos-sd]', :delayed
  end
end
