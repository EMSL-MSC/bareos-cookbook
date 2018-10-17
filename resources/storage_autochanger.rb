# Deploys and manages a single Bareos Storage Autochanger

property :autochanger_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_autochanger.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  package 'bareos-storage-tape'

  directory "autochanger_#{new_resource.name}_path" do
    path '/etc/bareos/bareos-sd.d/autochanger'
    owner 'bareos'
    group 'bareos'
    mode '0750'
    action :create
  end

  template "autochanger_#{new_resource.name}_config" do
    source new_resource.template_name
    path "/etc/bareos/bareos-sd.d/autochanger/#{new_resource.name}.conf"
    cookbook new_resource.template_cookbook
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      autochanger_config: new_resource.autochanger_config,
      autochanger_name: new_resource.name
    )
    notifies :restart, 'service[bareos-sd]', :delayed if bareos_resource?('service[bareos-sd]')
    action :create
  end
end
