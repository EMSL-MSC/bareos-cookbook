# Deploys and manages a single Bareos Client Message Config

property :message_config, Hash, required: true
property :message_custom_strings, Array, default: %w()
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'client_message.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "client_#{new_resource.name}_message_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-fd.d/messages/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      message_name: new_resource.name,
      message_config: new_resource.message_config,
      message_custom_strings: new_resource.message_custom_strings
    )
    notifies :restart, 'service[bareos-fd]', :delayed if bareos_resource?('service[bareos-fd]')
    action :create
  end
end
