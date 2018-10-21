# Deploys and manages a single Bareos Director Fileset Config

property :fileset_custom_strings, Array, default: %w()
property :fileset_include_config, Hash, default: {}
property :fileset_exclude_config, Hash, default: {}
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'director_fileset.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "director_#{new_resource.name}_fileset_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path "/etc/bareos/bareos-dir.d/fileset/#{new_resource.name}.conf"
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      fileset_name: new_resource.name,
      fileset_custom_strings: new_resource.fileset_custom_strings,
      fileset_include_config: new_resource.fileset_include_config,
      fileset_exclude_config: new_resource.fileset_exclude_config
    )
    notifies :restart, 'service[bareos-dir]', :delayed if bareos_resource?('service[bareos-dir]')
    action :create
  end
end
