# Deploys and manages a single Bareos Storage Storage Config

property :storage_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_daemon.erb'

action :create do
  include_recipe 'bareos::storage_daemon_common'

  template "storage_#{new_resource.name}_storage_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-sd.d/storage/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      storage_config: new_resource.storage_config,
      storage_name: new_resource.name
    )
    notifies :restart, 'service[bareos-sd]', :delayed
  end
end
