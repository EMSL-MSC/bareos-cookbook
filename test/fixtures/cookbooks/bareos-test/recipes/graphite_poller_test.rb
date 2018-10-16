# Install known python dependencies so the bareos-graphite-poller functions
django_install_cmd = if platform_family?('rhel') && node['platform_version'].to_i < 7
                       "pip install 'django==1.6.11'"
                     else
                       "pip install 'django' --upgrade"
                     end

bash 'install_bareos_graphite_poller_requirements' do
  code <<-EOH
source /opt/bareos_virtualenv/bin/activate
#{django_install_cmd}
pip install 'requests' --upgrade
deactivate
EOH
  not_if do
    ::Dir.exist?(
      '/opt/bareos_virtualenv/lib/python2.7/site-packages/django'
    )
  end
  not_if do
    ::Dir.exist?(
      '/opt/bareos_virtualenv/lib/python2.7/site-packages/requests'
    )
  end
end

# Test bareos_graphite_poller custom resource
plugin_config = chef_vault_item('bareos', 'config')

plugin_config[:bareos][:graphite].each do |poller_name, poller_config|
  bareos_graphite_poller poller_name do
    graphite_config poller_config
  end
end
