# Deploys and manages a single Bareos Client Director Config

property :director_config, Hash, required: true
property :director_custom_strings, Array, default: %w()
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'client_director.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "client_#{new_resource.name}_director_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-fd.d/director/#{new_resource.name}.conf"
    owner 'root'
    group 'bareos'
    mode '0640'
    variables(
      director_name: new_resource.name,
      director_config: new_resource.director_config,
      director_custom_strings: new_resource.director_custom_strings
    )
    notifies :restart, 'service[bareos-fd]', :delayed if bareos_resource?('service[bareos-fd]')
    action :create
  end
end
