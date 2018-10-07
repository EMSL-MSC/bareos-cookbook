package %w(python python-virtualenv python-pip)

execute 'virtualenv /opt/bareos_virtualenv --system-site-packages' do
  creates '/opt/bareos_virtualenv'
end

execute 'upgrade_pip' do
  command 'source /opt/bareos_virtualenv/bin/activate &&
  pip install pip --upgrade &&
  deactivate'
end
