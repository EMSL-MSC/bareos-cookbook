# Deploys and manages a single Bareos Storage Director Config

property :director_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'storage_daemon_director.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "storage_#{new_resource.name}_director_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-sd.d/director/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      director_name: new_resource.name,
      director_config: new_resource.director_config
    )
    notifies :restart, 'service[bareos-sd]', :delayed if bareos_resource?('service[bareos-sd]')
    action :create
  end
end
