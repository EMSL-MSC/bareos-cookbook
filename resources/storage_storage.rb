# Deploys and manages a single Bareos Storage Storage Config

property :storage_config, Hash, required: true
property :storage_custom_strings, Array, default: %w()
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_storage.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "storage_#{new_resource.name}_storage_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-sd.d/storage/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      storage_name: new_resource.name,
      storage_config: new_resource.storage_config,
      storage_custom_strings: new_resource.storage_custom_strings
    )
    notifies :restart, 'service[bareos-sd]', :delayed if bareos_resource?('service[bareos-sd]')
    action :create
  end
end
