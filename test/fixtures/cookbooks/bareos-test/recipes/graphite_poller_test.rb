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

# Bareos Contrib Graphite Poller Plugin Defaults and Examples
bareos_graphite_poller 'bareos_graphite_1' do
  graphite_config(
    'director_fqdn' => 'localhost',
    'director_name' => 'bareos-dir',
    'director_password' => 'directordirectorsecret',
    'graphite_endpoint' => 'graphite1',
    'graphite_port' => '2003',
    'graphite_prefix' => 'bareos1.'
  )
  not_if { platform?('ubuntu') && node['platform_version'].to_f >= 16.0 }
end

# Bareos Contrib Graphite Poller Plugin Defaults and Examples
bareos_graphite_poller 'bareos_graphite_2' do
  graphite_config(
    'director_fqdn' => 'localhost',
    'director_name' => 'bareos-dir',
    'director_password' => 'directordirectorsecret',
    'graphite_endpoint' => 'graphite2',
    'graphite_port' => '2003',
    'graphite_prefix' => 'bareos2.'
  )
  not_if { platform?('ubuntu') && node['platform_version'].to_f >= 16.0 }
end
