# Deploys and manages a single Bareos Storage Autochanger

property :autochanger_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_autochanger.erb'

default_action :create

action :create do
  include_recipe 'bareos::autochanger_setup'

  template "#{new_resource.name}_storage_autochanger" do
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
    notifies :restart, 'service[bareos-sd]', :delayed
    action :create
  end
end
