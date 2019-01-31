# Deploys and manages a single Bareos Storage NDMP Config

property :ndmp_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_daemon_ndmp.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "storage_#{new_resource.name}_ndmp_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-sd.d/ndmp/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      ndmp_name: new_resource.name,
      ndmp_config: new_resource.ndmp_config
    )
    notifies :restart, 'service[bareos-dir]', :delayed if bareos_resource?('service[bareos-dir]')
    action :create
  end
end
