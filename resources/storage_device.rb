# Deploys and manages a single Bareos Storage Device

property :device_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_daemon_device.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  package 'bareos-storage'

  directory "storage_#{new_resource.name}_device_dir" do
    path '/etc/bareos/bareos-sd.d/device'
    owner 'bareos'
    group 'bareos'
    mode '0750'
    action :create
  end

  template "storage_#{new_resource.name}_device_config" do
    source new_resource.template_name
    path "/etc/bareos/bareos-sd.d/device/#{new_resource.name}.conf"
    cookbook new_resource.template_cookbook
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      device_config: new_resource.device_config,
      device_name: new_resource.name
    )
    notifies :restart, 'service[bareos-sd]', :delayed if bareos_resource?('service[bareos-sd]')
    action :create
  end
end
