# Including the common Autochanger tasks so the resources will function
include_recipe 'bareos::console_common'

# Bareos Console Defaults and Examples
bareos_console 'default' do
  director_config(
    'bareos-dir' => [
      'address = localhost',
      'Password = "directordirectorsecret"',
      'Description = "Bareos Console credentials for local Director"',
    ]
  )
end
