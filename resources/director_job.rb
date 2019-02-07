# Deploys and manages a single Bareos Director Job Config

property :job_config, Hash, required: true
property :job_runscript_config, Hash, default: {}
property :job_custom_strings, Array, default: %w()
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'director_job.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "director_#{new_resource.name}_job_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-dir.d/job/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      job_name: new_resource.name,
      job_config: new_resource.job_config,
      job_runscript_config: new_resource.job_runscript_config,
      job_custom_strings: new_resource.job_custom_strings
    )
    notifies :restart, 'service[bareos-dir]', :delayed if bareos_resource?('service[bareos-dir]')
    action :create
  end
end
