# Deploys and manages a single Bareos Storage Mon Config

property :mon_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_daemon_mon.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  package 'bareos-storage'

  directory "storage_#{new_resource.name}_mon_dir" do
    path '/etc/bareos/bareos-sd.d/director'
    owner 'bareos'
    group 'bareos'
    mode '0750'
    action :create
  end

  template "storage_#{new_resource.name}_mon_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-sd.d/director/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      mon_config: new_resource.mon_config,
      mon_name: new_resource.name
    )
    notifies :restart, 'service[bareos-sd]', :delayed if bareos_resource?('service[bareos-sd]')
    action :create
  end
end
