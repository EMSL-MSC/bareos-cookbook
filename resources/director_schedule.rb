# Deploys and manages a single Bareos Director Schedule Config

property :schedule_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'director_schedule.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "director_#{new_resource.name}_schedule_config" do
    source new_resource.template_name
    path "/etc/bareos/bareos-dir.d/schedule/#{new_resource.name}.conf"
    cookbook new_resource.template_cookbook
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      schedule_name: new_resource.name,
      schedule_config: new_resource.schedule_config
    )
    notifies :restart, 'service[bareos-dir]', :delayed if bareos_resource?('service[bareos-dir]')
    action :create
  end
end
