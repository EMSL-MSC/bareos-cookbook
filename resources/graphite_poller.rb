# Deploys and configures an instance of the Bareos Graphite Plugin

property :graphite_config, Hash, required: true
property :src_dest_prefix, String, default: '/opt'
property :src_uri, String, default: 'https://raw.githubusercontent.com/bareos/bareos-contrib/master/misc/performance/graphite/bareos-graphite-poller.py'
property :src_checksum, String, default: '3c25e4b5bc6c76c8539ee105d53f9fb25fb2d7759645c4f5fa26e6ff7eb020b3'
property :plugin_owner, String, default: 'bareos'
property :plugin_group, String, default: 'bareos'
property :plugin_virtualenv_path, String, default: '/opt/bareos_virtualenv'
property :template_cookbook, String, default: 'bareos'
property :template_name, String, default: 'graphite_poller.erb'
property :manage_crontab, [true, false], default: true
property :crontab_mail_to, String, default: ''

action :create do
  if platform?('ubuntu') && node['platform_version'].to_f >= 16.0
    Chef::Log.fatal('The graphite_poller custom resource is not supported')
    Chef::Log.fatal('on Ubuntu versions greater than 14 at this time.')
    Chef::Log.fatal('Remove or guard this resource from running on these systems.')
    raise
  end
  package 'python-bareos'

  directory "#{new_resource.src_dest_prefix}/#{new_resource.name}" do
    owner new_resource.plugin_owner
    group new_resource.plugin_group
  end

  directory "#{new_resource.src_dest_prefix}/#{new_resource.name}/source" do
    owner new_resource.plugin_owner
    group new_resource.plugin_group
  end

  remote_file "#{new_resource.name}_py_script" do
    source new_resource.src_uri
    checksum new_resource.src_checksum
    path "#{new_resource.src_dest_prefix}/#{new_resource.name}/source/bareos-graphite-poller.py"
    owner new_resource.plugin_owner
    group new_resource.plugin_group
    mode 0750
  end

  template "#{new_resource.name}_conf" do
    source new_resource.template_name
    path "#{new_resource.src_dest_prefix}/#{new_resource.name}/source/graphite-poller.conf"
    cookbook new_resource.template_cookbook
    owner new_resource.plugin_owner
    group new_resource.plugin_group
    mode '0600'
    variables(
      graphite_config: new_resource.graphite_config
    )
  end

  cron "#{new_resource.name}_cron" do
    mailto new_resource.crontab_mail_to
    user new_resource.plugin_owner
    command %W(
      source #{new_resource.plugin_virtualenv_path}/bin/activate &&
      python #{new_resource.src_dest_prefix}/#{new_resource.name}/source/bareos-graphite-poller.py
      -c #{new_resource.src_dest_prefix}/#{new_resource.name}/source/graphite-poller.conf > /dev/null 2>&1;
      deactivate
    ).join(' ')
    only_if { new_resource.manage_crontab }
  end
end
