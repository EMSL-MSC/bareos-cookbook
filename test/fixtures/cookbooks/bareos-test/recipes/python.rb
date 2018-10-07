package %w(python python-virtualenv python-pip)

bash 'create_virtualenv' do
  code <<-EOH
virtualenv /opt/bareos_virtualenv --system-site-packages
EOH
  creates '/opt/bareos_virtualenv'
end

bash 'upgrade_pip' do
  code <<-EOH
source /opt/bareos_virtualenv/bin/activate
pip install pip --upgrade
deactivate
EOH
end
