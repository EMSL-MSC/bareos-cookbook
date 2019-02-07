# Deploys and manages a single Bareos Director JobDef Config

property :jobdef_config, Hash, required: true
property :jobdef_custom_strings, Array, default: %w()
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'director_jobdef.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "director_#{new_resource.name}_jobdef_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-dir.d/jobdefs/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      jobdef_name: new_resource.name,
      jobdef_config: new_resource.jobdef_config,
      jobdef_custom_strings: new_resource.jobdef_custom_strings
    )
    notifies :restart, 'service[bareos-dir]', :delayed if bareos_resource?('service[bareos-dir]')
    action :create
  end
end
