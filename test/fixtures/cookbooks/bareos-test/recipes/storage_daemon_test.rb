include_recipe 'bareos::autochanger_common'
include_recipe 'bareos::storage_daemon_common'

# Pulling hashes from databag but can also be node attributes
data_bag_content = chef_vault_item('bareos', 'config')
sd_config = data_bag_content[:bareos][:services][:storage_daemon]

# Test bareos_storage_storage resource w/data_bag/attribute style hash
sd_config[:storage].each do |storage_name, storage_config|
  bareos_storage_storage storage_name do
    storage_config storage_config
  end
end

# Test bareos_storage_director resource w/data_bag/attribute style hash
sd_config[:director].each do |director_name, director_config|
  bareos_storage_director director_name do
    director_config director_config
  end
end

# Test bareos_storage_mon resource w/data_bag/attribute style hash
sd_config[:mon].each do |mon_name, mon_config|
  bareos_storage_mon mon_name do
    mon_config mon_config
  end
end

# Test bareos_storage_messages resource w/data_bag/attribute style hash
sd_config[:messages].each do |messages_name, messages_config|
  bareos_storage_messages messages_name do
    messages_config messages_config
  end
end

# Test bareos_storage_autochanger resource w/data_bag/attribute style hash
sd_config[:autochanger].each do |autochanger_name, autochanger_config|
  bareos_storage_autochanger autochanger_name do
    autochanger_config autochanger_config
  end
end

# Test bareos_storage_device resource w/data_bag/attribute style hash
sd_config[:device].each do |device_name, device_config|
  bareos_storage_device device_name do
    device_config device_config
  end
end

# Test bareos_storage_device resource w/o attributes/databag style hash
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
