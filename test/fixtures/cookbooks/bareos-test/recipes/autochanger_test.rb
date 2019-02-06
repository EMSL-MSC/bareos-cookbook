# Including the common Autochanger tasks so the resources will function
include_recipe 'bareos::autochanger_common'

# Bareos Storage Autochanger Config Defaults and Examples
bareos_storage_autochanger 'autochanger-1-test' do
  autochanger_config(
    'Changer Command' => [
      '"/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"',
    ],
    'Changer Device' => [
      '/dev/tape/by-id/scsi-IBMLIBRARY1',
    ],
    'Description' =>  [
      '"autochanger-1-test config."',
    ],
    'Device' => %w(
      Example1
      Example2
    )
  )
  # action :nothing
end

bareos_storage_autochanger 'autochanger-2-test' do
  autochanger_config(
    'Changer Command' => [
      '"/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"',
    ],
    'Changer Device' => [
      '/dev/tape/by-id/scsi-IBMLIBRARY2',
    ],
    'Description' =>  [
      '"autochanger-2-test config."',
    ],
    'Device' => %w(
      Example3
      Example4
    )
  )
  # action :nothing
end
