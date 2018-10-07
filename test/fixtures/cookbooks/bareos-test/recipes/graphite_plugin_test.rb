django_install_cmd = if rhel? && node['platform_version'].to_i < 7
                       "pip install 'django<2.0.0'"
                     else
                       "pip install 'django' --upgrade"
                     end

bash 'install_bareos_graphite_requirements' do
  code <<-EOH
source /opt/bareos_virtualenv/bin/activate
#{django_install_cmd}
pip install 'requests' --upgrade
deactivate
EOH
end

dir1_vault = chef_vault_item('bareos_1', 'director_a')

dir1_vault['bareos']['graphite'].each do |k, v|
  bareos_graphite_plugin k do
    graphite v
    sensitive false
  end
end
