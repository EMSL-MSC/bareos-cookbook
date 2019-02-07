# Including the common Storage tasks so the resources will function
include_recipe 'bareos::storage_common'

# Example of pulling configs from databags/vaults but can also be node attributes
data_bag_content = chef_vault_item('bareos', 'config')
sd_device_config = data_bag_content['bareos']['services']['storage']['device']

# Bareos Storage Device Config Defaults and Examples
sd_device_config.each do |device_name, device_config|
  bareos_storage_device device_name do
    device_config device_config
    # action :nothing
  end
end

# Bareos Storage Storage Config Defaults and Examples
bareos_storage_storage 'bareos-sd' do
  storage_config(
    'Description' => [
      '"Default bareos-sd config."',
    ],
    'Maximum Concurrent Jobs': [
      '20',
    ],
    'SDPort': [
      '9103',
    ]
  )
end

# Bareos Storage Director Config Defaults and Examples
bareos_storage_director 'bareos-dir' do
  director_config(
    'Description' => [
      '"Director, who is permitted to contact this storage daemon."',
    ],
    'Password' => [
      '"storagedirectorsecretdir"',
    ]
  )
end

# Bareos Storage Director Config Defaults and Examples
bareos_storage_director 'bareos-mon' do
  director_config(
    'Description' => [
      '"Restricted Director, used by tray-monitor to get the status of this storage daemon."',
    ],
    'Monitor' => [
      'yes',
    ],
    'Password' => [
      '"storagedirectorsecretmon"',
    ]
  )
end

# Bareos Storage Message Config Defaults and Examples
bareos_storage_message 'Standard' do
  message_config(
    'Description' => [
      '"Send all messages to the Director."',
    ],
    'Director' => [
      'bareos-dir = all',
    ]
  )
end

# Bareos Storage Device Config Defaults and Examples
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
