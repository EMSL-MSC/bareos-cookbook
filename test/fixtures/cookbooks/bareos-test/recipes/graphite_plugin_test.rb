execute 'install_bareos_graphite_requirements' do
  command 'source /opt/bareos_virtualenv/bin/activate &&
  pip install django --upgrade &&
  pip install requests --upgrade &&
  deactivate'
end

dir1_vault = chef_vault_item('bareos_1', 'director_a')

dir1_vault['bareos']['graphite'].each do |k, v|
  bareos_graphite_plugin k do
    graphite v
    sensitive false
  end
end
