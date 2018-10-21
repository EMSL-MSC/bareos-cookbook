# Including the common Director tasks so the resources will function
include_recipe 'bareos::director_common'

# Bareos Director Schedule Defaults and Examples
bareos_director_schedule 'WeeklyCycleAfterBackup' do
  schedule_config(
    Description: ['"This schedule does the catalog. It starts after the WeeklyCycle."'],
    Run: ['Full mon-fri at 21:10']
  )
end
bareos_director_schedule 'WeeklyCycle' do
  schedule_config(
    Run: [
      'Full 1st sat at 21:00                   # (#04)',
      'Differential 2nd-5th sat at 21:00       # (#07)',
      'Incremental mon-fri at 21:00            # (#10)',
    ]
  )
end
bareos_director_schedule 'FirstOfMonthExample' do
  schedule_config(
    Run: [
      'Level=Full on 1 at 2:05',
      'Level=Incremental on 2-31 at 2:05',
    ]
  )
end

# Bareos Director Profile Defaults and Examples
bareos_director_profile 'operator' do
  profile_config(
    'Description' => ['"Profile allowing normal Bareos operations."'],
    'Command ACL' => [
      '!.bvfs_clear_cache, !.exit, !.sql',
      '!configure, !create, !delete, !purge, !prune, !sqlquery, !umount, !unmount',
      '*all*',
    ],
    'Catalog ACL' => ['*all*'],
    'Client ACL' => ['*all*'],
    'FileSet ACL' => ['*all*'],
    'Job ACL' => ['*all*'],
    'Plugin Options ACL' => ['*all*'],
    'Pool ACL' => ['*all*'],
    'Schedule ACL' => ['*all*'],
    'Storage ACL' => ['*all*'],
    'Where ACL' => ['*all*']
  )
end

# Bareos Director Pool Defaults and Examples
bareos_director_pool 'Scratch' do
  pool_config('Pool Type' => 'Scratch')
end
bareos_director_pool 'Incremental' do
  pool_config(
    'Pool Type' => 'Backup',
    'Recycle' => 'yes',
    'AutoPrune' => 'yes',
    'Volume Retention' => '30 days',
    'Maximum Volume Bytes' => '1G',
    'Maximum Volumes' => '100',
    'Label Format' => '"Incremental-"'
  )
end
bareos_director_pool 'Full' do
  pool_config(
    'Pool Type' => 'Backup',
    'Recycle' => 'yes',
    'AutoPrune' => 'yes',
    'Volume Retention' => '365 days',
    'Maximum Volume Bytes' => '50G',
    'Maximum Volumes' => '100',
    'Label Format' => '"Full-"'
  )
end
bareos_director_pool 'Differential' do
  pool_config(
    'Pool Type' => 'Backup',
    'Recycle' => 'yes',
    'AutoPrune' => 'yes',
    'Volume Retention' => '90 days',
    'Maximum Volume Bytes' => '10G',
    'Maximum Volumes' => '100',
    'Label Format' => '"Differential-"'
  )
end

# Bareos Director Console Defaults and Examples
bareos_director_console 'bareos-mon' do
  console_config(
    'Description' => '"Restricted console used by tray-monitor to get the status of the director."',
    'Password' => '"NOTSOSUPERSECRETPASSWORD"',
    'CommandACL' => 'status, .status',
    'JobACL' => '*all*'
  )
end

# Bareos Director Client Defaults and Examples
bareos_director_client 'bareos-fd' do
  client_config(
    'Description' => '"Client resource of the Director itself."',
    'Address' => 'localhost',
    'Password' => '"ALSONOTSOSECRETAPASSWORDSOCHANGEIT"'
  )
end

# Bareos Director Fileset Defaults and Examples
bareos_director_fileset 'test-1-all' do
  fileset_custom_strings [
    '#custom string 1',
    '#custom string 2',
    '#custom string 3',
  ]
  fileset_include_config(
    'include set 1' => {
      'options' => {
        'options 1 set 1' => [
          '#ption 1 string 1',
          '#option 1 string 2',
          '#option 1 string 3',
        ],
        'options 1 set 2' => [
          '#option 1 string 1',
          '#option 1 string 2',
          '#option 1 string 3',
        ],
      },
      'file' => [
        '#file 1 string 1',
        '#file 1 string 2',
        '#file 1 string 3',
      ],
      'exclude_dir_containing' => [
        '#exclude 1 string 1',
        '#exclude 1 string 2',
        '#exclude 1 string 3',
      ],
    },
    'include set 2' => {
      'options' => {
        'options 2 set 1' => [
          '#option 2 string 1',
          '#option 2 string 2',
          '#option 2 string 3',
        ],
        'options 2 set 2' => [
          '#option 2 string 1',
          '#option 2 string 2',
          '#option 2 string 3',
        ],
      },
      'file' => [
        '#file 2 string 1',
        '#file 2 string 2',
        '#file 2 string 3',
      ],
      'exclude_dir_containing' => [
        '#exclude 2 string 1',
        '#exclude 2 string 2',
        '#exclude 2 string 3',
      ],
    }
  )
  fileset_exclude_config(
    'exclude set 1' => [
      '#exclude 1 this 1',
      '#exclude 1 this 2',
      '#exclude 1 this 3',
    ],
    'exclude set 2' => [
      '#exclude 2 this 1',
      '#exclude 2 this 2',
      '#exclude 2 this 3',
    ]
  )
end

bareos_director_fileset 'test-2-custom-strings-only' do
  fileset_custom_strings [
    '#custom string 1',
  ]
end

bareos_director_fileset 'test-3-includes-only-with-nil' do
  fileset_include_config(
    'include set 1' => {
      'options' => {
        'options 1 set 1' => [
        ],
        'options 1 set 2' => [
          '#option 1 string 1',
        ],
      },
    },
    'include set 2' => {
    }
  )
end

bareos_director_fileset 'test-4-excludes-only-with-empty' do
  fileset_exclude_config(
    'exclude set 1' => [
      '#exclude 1 this 1',
    ],
    'exclude set 2' => []
  )
end

bareos_director_fileset 'test-5-none'

bareos_director_fileset 'Windows All Drives' do
  fileset_custom_strings [
    'Enable VSS = yes',
  ]
  fileset_include_config(
    'main include' => {
      'options' => {
        'main options' => [
          'Signature = MD5',
          'Drive Type = fixed',
          'IgnoreCase = yes',
          'WildFile = "[A-Z]:/pagefile.sys"',
          'WildDir = "[A-Z]:/RECYCLER"',
          'WildDir = "[A-Z]:/$RECYCLE.BIN"',
          'WildDir = "[A-Z]:/System Volume Information"',
          'Exclude = yes',
        ],
      },
      'file' => [
        'File = /',
      ],
    }
  )
end

bareos_director_fileset 'SelfTest' do
  fileset_custom_strings [
    'Description = "fileset just to backup some files for selftest"',
  ]
  fileset_include_config(
    'main include' => {
      'options' => {
        'main options' => [
          'Signature = MD5 # calculate md5 checksum per file',
        ],
      },
      'file' => [
        'File = "/usr/sbin"',
      ],
    }
  )
end

bareos_director_fileset 'LinuxAll' do
  fileset_custom_strings [
    'Description = "Backup all regular filesystems, determined by filesystem type."',
  ]
  fileset_include_config(
    'main include' => {
      'options' => {
        'main options' => [
          'Signature = MD5 # calculate md5 checksum per file',
          'One FS = No     # change into other filessytems',
          'FS Type = btrfs',
          'FS Type = ext2  # filesystems of given types will be backed up',
          'FS Type = ext3  # others will be ignored',
          'FS Type = ext4',
          'FS Type = reiserfs',
          'FS Type = jfs',
          'FS Type = xfs',
          'FS Type = zfs',
        ],
      },
      'file' => [
        'File = /',
      ],
    }
  )
  fileset_exclude_config(
    'main exclude list' => [
      'File = /var/lib/bareos',
      'File = /var/lib/bareos/storage',
      'File = /proc',
      'File = /tmp',
      'File = /var/tmp',
      'File = /.journal',
      'File = /.fsck',
    ]
  )
end

bareos_director_fileset 'Catalog' do
  fileset_custom_strings [
    'Description = "Backup the catalog dump and Bareos configuration files."',
  ]
  fileset_include_config(
    'main include' => {
      'options' => {
        'main options' => [
          'signature = MD5',
        ],
      },
      'file' => [
        'File = "/var/lib/bareos/bareos.sql" # database dump',
        'File = "/etc/bareos"                   # configuration',
      ],
    }
  )
end
