# Deploys and manages a single Bareos Director Pool Config

property :pool_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'director_pool.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "director_#{new_resource.name}_pool_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-dir.d/pool/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      pool_name: new_resource.name,
      pool_config: new_resource.pool_config
    )
    notifies :restart, 'service[bareos-dir]', :delayed if bareos_resource?('service[bareos-dir]')
    action :create
  end
end
