# Deploys and manages a single Bareos Director Client Config

property :client_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'director_client.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "director_#{new_resource.name}_client_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-dir.d/client/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      client_name: new_resource.name,
      client_config: new_resource.client_config
    )
    notifies :restart, 'service[bareos-dir]', :delayed if bareos_resource?('service[bareos-dir]')
    action :create
  end
end
