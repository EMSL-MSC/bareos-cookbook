data_bag_content = chef_vault_item('bareos', 'config')
sd_config = data_bag_content[:bareos][:services][:storage_daemon]

sd_config[:storage].each do |storage_name, storage_config|
  bareos_storage_storage storage_name do
    storage_config storage_config
  end
end

sd_config[:director].each do |director_name, director_config|
  bareos_storage_director director_name do
    director_config director_config
  end
end

sd_config[:mon].each do |mon_name, mon_config|
  bareos_storage_mon mon_name do
    mon_config mon_config
  end
end

sd_config[:messages].each do |messages_name, messages_config|
  bareos_storage_messages messages_name do
    messages_config messages_config
  end
end

default_filestorage = {
  'Media Type' => 'File',
  'Archive Device' => '/var/lib/bareos/storage',
  'LabelMedia' => 'yes;',
  'Random Access' => 'yes;',
  'AutomaticMount' => 'yes;',
  'RemovableMedia' => 'no;',
  'AlwaysOpen' => 'no;',
  'Description' => '"File device. A connecting Director must have the same Name and MediaType."',
}
bareos_storage_device 'FileStorage' do
  device_config default_filestorage
end

# Test bareos_storage_autochanger resource
ac_config = chef_vault_item('bareos', 'config')
ac_config[:bareos][:services][:storage_daemon][:autochanger].each do |k, v|
  bareos_storage_autochanger k do
    autochanger_config v
  end
end

# Test bareos_storage_device resource
dev_config = chef_vault_item('bareos', 'config')
dev_config[:bareos][:services][:storage_daemon][:device].each do |k, v|
  bareos_storage_device k do
    device_config v
  end
end
