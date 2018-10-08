# Test bareos_storage_device resource
dev_config = chef_vault_item('bareos', 'config')

dev_config['bareos']['services']['storage_daemon']['device'].each do |k, v|
  bareos_storage_device k do
    device_config v
  end
end
