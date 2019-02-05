# Chef bareos-cookbook

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Cookbook Version](https://img.shields.io/cookbook/v/bareos.svg)](https://supermarket.chef.io/cookbooks/bareos)
[![Build Status](https://travis-ci.org/EMSL-MSC/bareos-cookbook.svg?branch=master)](https://travis-ci.org/EMSL-MSC/bareos-cookbook)

Deploy and manage [Bareos](https://www.bareos.org) with Chef Custom Resources

## Deployment Strategy

This cookbook is intended to provide a Chef custom resource library for deploying and managing Bareos in a standard linux environment. There are a few recipes provided but are optional in that the resources should operate independently given a Bareos installation already exists or is installed alongside (i.e. packages, repos, directory structure). This strategy might change to some degree in the future but for now seemed to be the simplest way to separate the server setup tasks from the deployment of specific resources.

Use of these custom resources can be instantiated by way of features such as chef-vault for secret management, chef attributes, chef databags, etc. They are heavily reliant on hash and/or arrays to drop configurations into place and should provide a lot of flexibility but also provide the structure needed to manage Bareos resources as described per Bareos documentation. Templates can be replaced in wrapper cookbooks by way of the `template_cookbook` and `template_name` functionality of each custom resource. Issues or pull requests for official changes are also welcome.

## Deployment Considerations

This cookbook does not and will not manage ancillary services for you such as PostgreSQL, MySQL, Python, Apache, Yum EPEL Repositories, etc. In the test fixture cookbook, there are some simple examples to get you going in the right direction. They are minimally configured for testing purposes only. You will need to make a plan to support a database type, Python, Apache/Nginx (optionally), and Yum EPEL repositories in RedHat based systems.

## Supported Platforms

Platform | Version
-------- | -------------------------
Centos   | `6.10`, `7.6.1804`
Debian   | `8.9`, `9.5`
Ubuntu   | `14.04`, `16.04`, `18.04`

## Supplementary Recipes

All listed recipes provide some minimal ability to:

1. Manage Bareos directory structure
2. Manage Bareos package repositories
3. Install Bareos packages

`default.rb` - Setup source repositories and install simple list of Bareos packages based on Bareos OpenSource sources

`package_install_common.rb` - Install common Bareos packages

`package_repos_common.rb` - Setup Bareos source repositories via Yum or Apt

`client_common.rb` - Common set of tasks related to setting up Bareos Client resources per docs

`console_common.rb` - Common set of tasks related to setting up Bareos Console resources per docs

`director_common.rb` - Common set of tasks related to setting up Bareos Director resources per docs

`storage_common.rb` - Common set of tasks related to setting up Bareos Storage resources per docs

`autochanger_common.rb` - Common set of tasks related to setting up Bareos Autochanger resources per docs. Actively tested against an IBM TS3500 with 16 Drives and 3PB of LTO4 Tape cartridges.

## Default Attributes

See `attributes/dafault.rb`

## Available Resources (Should align with [docs](http://doc.bareos.org/master/html/bareos-manual-main-reference.html#ResourceTypes))

Resource    | Director | Client | Storage | Console
----------- | -------- | ------ | ------- | -------
Autochanger |          |        | X       |
Catalog     | X        |        |         |
Client      | X        | X      |         |
Console     | X        |        |         | X
Device      |          |        | X       |
Director    | X        | X      | X       | X
Fileset     | X        |        |         |
Job         | X        |        |         |
JobDefs     | X        |        |         |
Message     | X        | X      | X       |
NDMP        |          |        | X       |
Pool        | X        |        |         |
Profile     | X        |        |         |
Schedule    | X        |        |         |
Storage     | X        |        | X       |

## Custom Resources and Examples

These and other examples are found under `test/fixtures/cookbooks/bareos-test`.

### Director

#### director_catalog

Default action is `:create` which creates the necessary database, schemas, and authentication for PostgreSQL or MySQL via Bareos provided tools/scripts.

**WARNING:** Do **_NOT_** create multiple catalogs for your installation per [Bareos Docs](http://doc.bareos.org/master/html/bareos-manual-main-reference.html#CurrentImplementationRestrictions)

##### Parameters

- `catalog_config` - Hash, default:

  ```ruby
  {
    dbname: 'bareos',
    dbuser: 'bareos',
    dbpassword: ''
  }
  ```

- `catalog_backend` - String, default `'postgresql'` and only accepts one of `'postgresql'` or `'mysql'`

- `template_name` - String, default `'director_catalog.erb'`

- `template_cookbook` - String, default `'bareos'`

##### Example Usage

```ruby
# Deploy the single default Bareos Catalog
bareos_director_catalog 'MyCatalog' do
  catalog_config(
    dbname: 'bareos',
    dbuser: 'bareos',
    dbpassword: ''
  )
  catalog_backend 'postgresql'
  template_name 'director_catalog.erb'
  template_cookbook 'bareos'
  action :create
end
```

#### director_client

Default action is `:create` which generates a director client resource.

##### Parameters

- `client_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_client.erb'`

##### Example Usage

```ruby
# Bareos Director Client Defaults and Examples
bareos_director_client 'bareos-fd' do
  client_config(
    'Description' => '"Client resource of the Director itself."',
    'Address' => 'localhost',
    'Password' => '"ALSONOTSOSECRETAPASSWORDSOCHANGEIT"'
  )
end
```

#### director_console

Default action is `:create` which generates a director console resource.

##### Parameters

- `console_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_console.erb'`

##### Example Usage

```ruby
# Bareos Director Console Defaults and Examples
bareos_director_console 'bareos-mon' do
  console_config(
    'Description' => '"Restricted console used by tray-monitor to get the status of the director."',
    'Password' => '"NOTSOSUPERSECRETPASSWORD"',
    'CommandACL' => 'status, .status',
    'JobACL' => '*all*'
  )
end
```

#### director_director

Default action is `:create` which generates a director director resource.

##### Parameters

- `director_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_director.erb'`

##### Example Usage

```ruby
# WIP
```

#### director_fileset

Default action is `:create` which generates a director fileset resource.

##### Parameters

- `fileset_custom_strings` - Array, default `%w()`
- `fileset_include_config` - Hash, default `{}`
- `fileset_exclude_config` - Hash, default `{}`
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_fileset.erb'`

##### Example Usage

```ruby
# Bareos Director FileSet Defaults and Examples
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
          '#option 1 string 1',
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
```

#### director_job

Default action is `:create` which generates a director job resource.

##### Parameters

- `job_config` - Hash, input required
- `job_runscript_config` - Hash, default `{}`
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_job.erb'`

##### Example Usage

```ruby
# Bareos Director Job Defaults and Examples
bareos_director_job 'BackupCatalog' do
  job_config(
    'Description' => '"Backup the catalog database (after the nightly save)"',
    'JobDefs' => '"DefaultJob"',
    'Level' => 'Full',
    'FileSet' => '"Catalog"',
    'Schedule' => '"WeeklyCycleAfterBackup"',
    'RunBeforeJob' => '"/usr/lib/bareos/scripts/make_catalog_backup.pl MyCatalog"',
    'RunAfterJob' => '"/usr/lib/bareos/scripts/delete_catalog_backup"',
    'Write Bootstrap' => '"|/usr/bin/bsmtp -h localhost -f \"\(Bareos\) \" -s \"Bootstrap for Job %j\" root@localhost" # (#01)',
    'Priority' => '11'
  )
  job_runscript_config(
    'from doc example' => {
      'Command' => '"echo test"',
      'Runs When' => 'After',
      'Runs On Failure' => 'yes',
      'Runs On Client'  => 'no',
      'Runs On Success' => 'yes',
    }
  )
end
```

#### director_jobdef

Default action is `:create` which generates a director jobdef resource.

##### Parameters

- `jobdef_config` - Hash, input required
- `template_cookbook` - String, default: `'bareos'`
- `template_name` - String, default `'director_jobdef.erb'`

##### Example Usage

```ruby
# Bareos Director JobDef Defaults and Examples
bareos_director_jobdef 'DefaultJob' do
  jobdef_config(
    'Description' => '"This is the default jobdef provided by the Bareos package"',
    'Type' => 'Backup',
    'Level' => 'Incremental',
    'Client' => 'bareos-fd',
    'FileSet' => '"SelfTest"                     # selftest fileset                            (#13)',
    'Schedule' => '"WeeklyCycle"',
    'Storage' => 'File',
    'Messages' => 'Standard',
    'Pool' => 'Incremental',
    'Priority' => '10',
    'Write Bootstrap' => '"/var/lib/bareos/%c.bsr"',
    'Full Backup Pool' => 'Full                  # write Full Backups into "Full" Pool         (#05)',
    'Differential Backup Pool' => 'Differential  # write Diff Backups into "Differential" Pool (#08)',
    'Incremental Backup Pool' => 'Incremental    # write Incr Backups into "Incremental" Pool  (#11)'
  )
end
```

#### director_message

Default action is `:create` which generates a director message resource.

##### Parameters

- `message_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_message.erb'`

##### Example Usage

```ruby
# WIP
```

#### director_pool

Default action is `:create` which generates a director pool resource.

##### Parameters

- `pool_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_pool.erb'`

##### Example Usage

```ruby
# Bareos Director Pool Defaults and Examples
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
```

#### director_profile

Default action is `:create` which generates a director profile resource.

##### Parameters

- `profile_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_profile.erb'`

##### Example Usage

```ruby
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
```

#### director_schedule

Default action is `:create` which generates a director schedule resource.

##### Parameters

- `schedule_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_schedule.erb'`

##### Example Usage

```ruby
# Bareos Director Schedule Defaults and Examples
bareos_director_schedule 'WeeklyCycle' do
  schedule_config(
    Run: [
      'Full 1st sat at 21:00                   # (#04)',
      'Differential 2nd-5th sat at 21:00       # (#07)',
      'Incremental mon-fri at 21:00            # (#10)',
    ]
  )
end
```

#### director_storage

Default action is `:create` which generates a director storage resource.

##### Parameters

- `storage_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'director_storage.erb'`

##### Example Usage

```ruby
# WIP
```

### Storage

#### storage_autochanger

Default action is `:create` which generates a storage autochanger resource.

##### Parameters

- `autochanger_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'storage_autochanger.erb'`

##### Example Usage

```ruby
bareos_storage_autochanger 'test-autochanger' do
  autochanger_config(
    'Changer Command' => [
      '"/usr/lib/bareos/scripts/mtx-changer %c %o %S %a %d"'
    ],
    'Changer Device' => [
      '/dev/tape/by-id/scsi-IBMLIBRARY'
    ],
    'Description' => [
      'Test AutoChanger config'
    ],
    'Device' => [
      'Example1',
      'Example2'
    ]
  )
end
```

#### storage_device

Default action is `:create` which generates a storage device resource.

##### Parameters

- `device_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'storage_device.erb'`

##### Example Usage

```ruby
bareos_storage_device 'ExampleDevice' do
  device_config(
    "AlwaysOpen" => "yes;",
    "ArchiveDevice" => "/dev/tape/by-id/scsi-IBMTAPEDRIVE-nst",
    "Autochanger" => "yes",
    "AutomaticMount" => "yes;",
    "Autoselect" => "no",
    "Description" => "\"Example Tape Drive.\"",
    "DeviceType" => "tape",
    "DriveIndex" => "0",
    "Maximum Changer Wait" => "30 minutes",
    "Maximum Concurrent Jobs" => "1",
    "Maximum File Size" => "20G",
    "Maximum Job Spool Size" => "50G",
    "Maximum Rewind Wait" => "30 minutes",
    "Maximum Spool Size" => "50G",
    "MediaType" => "LTO-4",
    "Spool Directory" => "/spool"
  )
end
```

#### storage_director

Default action is `:create` which generates a storage director resource.

##### Parameters

- `director_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'storage_director.erb'`

##### Example Usage

```ruby
# WIP
```

#### storage_message

Default action is `:create` which generates a storage message resource.

##### Parameters

- `message_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'storage_message.erb'`

##### Example Usage

```ruby
# WIP
```

#### storage_ndmp

Default action is `:create` which generates a storage ndmp resource.

##### Parameters

- `ndmp_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'storage_ndmp.erb'`

##### Example Usage

```ruby
# WIP
```

#### storage_storage

Default action is `:create` which generates a storage storage resource.

##### Parameters

- `storage_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'storage_storage.erb'`

##### Example Usage

```ruby
# WIP
```

### Client

#### client_client

Default action is `:create` which generates a client client resource.

##### Parameters

- `client_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'client_client.erb'`

##### Example Usage

```ruby
# WIP
```

#### client_director

Default action is `:create` which generates a client director resource.

##### Parameters

- `director_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'client_director.erb'`

##### Example Usage

```ruby
# WIP
```

#### client_message

Default action is `:create` which generates a client message resource.

##### Parameters

- `message_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'client_message.erb'`

##### Example Usage

```ruby
# WIP
```

### Console

#### console_console

Default action is `:create` which generates a console console resource.

##### Parameters

- `console_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'console_console.erb'`

##### Example Usage

```ruby
# WIP
```

#### console_director

Default action is `:create` which generates a console director resource.

##### Parameters

- `director_config` - Hash, input required
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'console_director.erb'`

##### Example Usage

```ruby
# WIP
```

## Other Cookbook Features/Resources

### Graphite Poller (Bareos Contrib Repository)

#### Description

If you have a graphite node/cluster to monitor systems, we have a custom resource that installs the plugin and configures a cronjob (optionally and configurable) to simply send job statistics to the graphite cluster.

It could fall out of date as we have locked down to a specific commit but we can change that if users start to see issues with the one we are deploying by default.

**SPECIAL NOTE:** This custom resource does not currently support Ubuntu `>= 16`. The custom resource will post an error in your chef-client log in those cases.

#### graphite_poller (Custom Resource)

Default action is `:create` which generates an instance of the Bareos graphite poller.

##### Parameters

- `graphite_config` - Hash, input required
- `src_dest_prefix` - String, default `'/opt'`
- `src_uri` - String, default `'https://raw.githubusercontent.com/bareos/bareos-contrib/master/misc/performance/graphite/bareos-graphite-poller.py'`
- `src_checksum` - String, default `'3c25e4b5bc6c76c8539ee105d53f9fb25fb2d7759645c4f5fa26e6ff7eb020b3'`
- `plugin_owner` - String, default `'bareos'`
- `plugin_group` - String, default `'bareos'`
- `plugin_virtualenv_path` - String, default `'/opt/bareos_virtualenv'`
- `template_cookbook` - String, default `'bareos'`
- `template_name` - String, default `'graphite_poller.erb'`
- `manage_crontab` - Boolean, default `true`
- `crontab_mail_to` - String, default `''`

##### Example Usage

```ruby
bareos_graphite_poller 'bareos_graphite' do
  graphite_config(
    'director_fqdn' => 'localhost',
    'director_name' => 'bareos-dir',
    'director_password' => 'testpassnotsecret',
    'graphite_endpoint' => 'graphite',
    'graphite_port' => '2003',
    'graphite_prefix' => 'bareos.'
  )
  not_if { platform?('ubuntu') && node['platform_version'].to_f >= 16.0 }
end
```

# Contributing

You fixed a bug, or added a new feature?

1. File an issue with this repo
2. Fork the repository on Github
3. Create a named feature branch (like `add\_component\_x`)
4. Write your change
5. Write tests for your change (if applicable)
6. Run the tests, ensuring they all pass
7. Submit a Pull Request using Github, adding an issue tag like `Fixes #x`

Contributions of any sort are very welcome!

# Authors

Authors: Ian Smith <gitbytes@gmail.com>
