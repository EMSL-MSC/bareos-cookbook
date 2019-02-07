# Deploys and manages a single Bareos Client Client Config

property :client_config, Hash, required: true
property :client_custom_strings, Array, default: %w()
property :client_name, [String, nil], default: nil
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'client_client.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "client_#{new_resource.name}_client_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-fd.d/client/#{new_resource.name}.conf"
    owner 'root'
    group 'bareos'
    mode '0640'
    variables(
      client_name: new_resource.client_name,
      client_config: new_resource.client_config,
      client_custom_strings: new_resource.client_custom_strings
    )
    notifies :restart, 'service[bareos-fd]', :delayed if bareos_resource?('service[bareos-fd]')
    action :create
  end
end
