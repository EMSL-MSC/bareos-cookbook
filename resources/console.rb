# Deploys and manages a single Bareos Console Config (director/console)

property :console_config, Hash, default: {}
property :director_config, Hash, default: {
  'bareos-dir' => [
    'address = localhost',
    'Password = "XXXXXXXXXXXXX"',
    'Description = "Bareos Console credentials for local Director"',
  ],
}
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'console_console_director.erb'

default_action :create

action_class do
  include BareosCookbook::Helper
end

action :create do
  template "console_#{new_resource.name}_config" do
    source new_resource.template_name
    cookbook new_resource.template_cookbook
    path '/etc/bareos/bconsole.conf'
    owner 'root'
    group 'bareos'
    mode '0640'
    variables(
      console_config: new_resource.console_config,
      director_config: new_resource.director_config
    )
    action :create
  end
end
