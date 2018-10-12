# Deploys and manages a single Bareos Storage Messages Config

property :messages_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_daemon_messages.erb'

action :create do
  include_recipe 'bareos::storage_daemon_common'

  template "storage_#{new_resource.name}_messages_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-sd.d/messages/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      messages_config: new_resource.messages_config,
      messages_name: new_resource.name
    )
    notifies :restart, 'service[bareos-sd]', :delayed
  end
end
