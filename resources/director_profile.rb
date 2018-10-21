# Deploys and manages a single Bareos Director Profile Config

property :profile_config, Hash, required: true
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'director_profile.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "director_#{new_resource.name}_profile_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-dir.d/profile/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      profile_config: new_resource.profile_config,
      profile_name: new_resource.name
    )
    notifies :restart, 'service[bareos-dir]', :delayed if bareos_resource?('service[bareos-dir]')
    action :create
  end
end
