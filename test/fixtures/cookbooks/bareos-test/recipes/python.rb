package %w(python python-virtualenv python-pip)

bash 'create_virtualenv' do
  code <<-EOH
virtualenv /opt/bareos_virtualenv --system-site-packages
EOH
  creates '/opt/bareos_virtualenv'
end

pip_install_cmd = if rhel? && node['platform_version'].to_i < 7
                    'pip install pip==7.0.1'
                  else
                    'pip install pip --upgrade'
                  end

bash 'upgrade_pip' do
  code <<-EOH
source /opt/bareos_virtualenv/bin/activate
#{pip_install_cmd}
pip -V
deactivate
EOH
end
