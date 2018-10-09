# Deploys and manages a single Bareos Storage Device

property :device_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_device.erb'

default_action :create

action :create do
  template "#{new_resource.name}_storage_device" do
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
    notifies :restart, "service[bareos-sd]", :delayed
    action :create
  end
end
