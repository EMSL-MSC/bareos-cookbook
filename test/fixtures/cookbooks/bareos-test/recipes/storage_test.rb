# Including the common Storage tasks so the resources will function
include_recipe 'bareos::storage_common'

# Pulling hashes from databag but can also be node attributes
data_bag_content = chef_vault_item('bareos', 'config')
sd_config = data_bag_content[:bareos][:services][:storage]

# Bareos Storage Storage Config Defaults and Examples
sd_config[:storage].each do |storage_name, storage_config|
  bareos_storage_storage storage_name do
    storage_config storage_config
  end
end

# Bareos Storage Director Config Defaults and Examples
sd_config[:director].each do |director_name, director_config|
  bareos_storage_director director_name do
    director_config director_config
  end
end

# Bareos Storage Message Config Defaults and Examples
sd_config[:message].each do |message_name, message_config|
  bareos_storage_message message_name do
    message_config message_config
  end
end

# Bareos Storage Autochanger Config Defaults and Examples
sd_config[:autochanger].each do |autochanger_name, autochanger_config|
  bareos_storage_autochanger autochanger_name do
    autochanger_config autochanger_config
  end
end

# Bareos Storage Device Config Defaults and Examples
sd_config[:device].each do |device_name, device_config|
  bareos_storage_device device_name do
    device_config device_config
  end
end
bareos_storage_device 'FileStorage' do
  device_config(
    'Media Type' => 'File',
    'Archive Device' => '/var/lib/bareos/storage',
    'LabelMedia' => 'yes;',
    'Random Access' => 'yes;',
    'AutomaticMount' => 'yes;',
    'RemovableMedia' => 'no;',
    'AlwaysOpen' => 'no;',
    'Description' => '"File device. A connecting Director must have the same Name and MediaType."'
  )
end

# Bareos Storage NDMP Config Examples
bareos_storage_ndmp 'bareos-dir-isilon' do
  ndmp_config(
    'Username' => 'ndmpadmin',
    'Password' => 'test',
    'AuthType' => 'Clear'
  )
end