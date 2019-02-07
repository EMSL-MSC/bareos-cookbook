# Including the common Autochanger tasks so the resources will function
include_recipe 'bareos::client_common'

# Bareos Client Client Defaults and Examples
bareos_client_client 'myself' do
  client_config(
    'Maximum Concurrent Jobs' => '20'
  )
end

# Bareos Client Director Defaults and Examples
bareos_client_director 'bareos-dir' do
  director_config(
    'Password' => '"clientdirectorsecretdir"',
    'Description' => '"Allow the configured Director to access this file daemon."'
  )
end

# Bareos Client Director Defaults and Examples
bareos_client_director 'bareos-mon' do
  director_config(
    'Password' => '"clientdirectorsecretmon"',
    'Monitor' => 'yes',
    'Description' => '"Restricted Director, used by tray-monitor to get the status of this file daemon."'
  )
end

# Bareos Client Message Defaults and Examples
bareos_client_message 'Standard' do
  message_config(
    'Director' => 'bareos-dir = all, !skipped, !restored',
    'Description' => '"Send relevant messages to the Director."'
  )
end
