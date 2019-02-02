# Chef bareos-cookbook
[![Build Status](https://travis-ci.org/EMSL-MSC/bareos-cookbook.svg?branch=master)](https://travis-ci.org/EMSL-MSC/bareos-cookbook)

Deploy and manage Bareos (https://www.bareos.org) with Chef Custom Resources

## Deployment Strategy
This cookbook is intended to provide a Chef custom resource library for deploying and managing Bareos in a standard linux environment. There are a few recipes provided but are optional in that the resources should operate independently given a Bareos installation already exists or is installed alongside (i.e. packages, repos, directory structure). This strategy might change to some degree in the future but for now seemed to be the simplest way to separate the server setup tasks from the deployment of specific resources.

Use of these custom resources can be instantiated by way of features such as chef-vault for secret management, chef attributes, chef databags, etc. They are heavily reliant on hash and/or arrays to drop configurations into place and should provide a lot of flexibility but also provide the structure needed to manage Bareos resources as described per Bareos documentation. Templates can be replaced in wrapper cookbooks by way of the Chef `edit_resource` functionality, or submit an issue for an official fix.

## Supported Platforms
| Platform | Version                   |
| -------- | ------------------------- |
| Centos   | `6.10`, `7.6.1804`        |
| Debian   | `8.9`, `9.5`              |
| Ubuntu   | `14.04`, `16.04`, `18.04` |

## Supplementary Recipes
All listed recipes provide some minimal ability to:
1. Manage Bareos directory structure
1. Manage Bareos package repositories
1. Install Bareos packages

### `default.rb`
Setup source repositories and install simple list of Bareos packages based on Bareos OpenSource sources
### `package_install_common.rb`
Install common Bareos packages
### `package_repos_common.rb`
Setup Bareos source repositories via Yum or Apt
### `client_common.rb`
Common set of tasks related to setting up Bareos Client resources per docs
### `console_common.rb`
Common set of tasks related to setting up Bareos Console resources per docs
### `director_common.rb`
Common set of tasks related to setting up Bareos Director resources per docs
### `storage_common.rb`
Common set of tasks related to setting up Bareos Storage resources per docs
### `autochanger_common.rb`
Common set of tasks related to setting up Bareos Autochanger resources per docs.
Actively tested against an IBM TS3500 with 16 Drives and 3PB of LTO4 Tape cartridges.

## Available Resources (Should align with [docs](http://doc.bareos.org/master/html/bareos-manual-main-reference.html#ResourceTypes))
| Resource    | Director | Client | Storage | Console |
| ----------- | -------- | ------ | ------- | ------- |
| Autochanger |          |        | X       |         |
| Catalog     | X        |        |         |         |
| Client      | X        | X      |         |         |
| Console     | X        |        |         | X       |
| Device      |          |        | X       |         |
| Director    | X        | X      | X       | X       |
| Fileset     | X        |        |         |         |
| Job         | X        |        |         |         |
| JobDefs     | X        |        |         |         |
| Message     | X        | X      | X       |         |
| NDMP        |          |        | X       |         |
| Pool        | X        |        |         |         |
| Profile     | X        |        |         |         |
| Schedule    | X        |        |         |         |
| Storage     | X        |        | X       |         |

## Custom Resources and Examples

### Director
#### director_catalog
Default action is `:create` which creates the necessary database schemas in PostgreSQL or MySQL via Bareos provided tools/scripts.

##### __*NOTICE__ #####
Do ___NOT___ create multiple catalogs for your installation per [Bareos Docs](http://doc.bareos.org/master/html/bareos-manual-main-reference.html#CurrentImplementationRestrictions)

##### Parameters
- `catalog_config` - Hash, Defaults to bareos (db name, db user) and blank db password
- `catalog_backend` - String, Defaults to PostgreSQL
- `template_name` - String, Defaults to `director_catalog.erb`
- `template_cookbook` - String, Defaults to `bareos`
- `catalog_host` - String, Defaults to node FQDN if detected

##### Example Usage
```
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
#### director_console
#### director_director
#### director_fileset
#### director_job
#### director_jobdef
#### director_message
#### director_pool
#### director_profile
#### director_schedule
#### director_storage

### Storage
#### storage_autochanger
#### storage_device
#### storage_director
#### storage_message
#### storage_ndmp
#### storage_storage

### Client
#### client_client
#### client_director
#### client_message

### Console
#### console_console
#### console_director

## Other Cookbook Features/Resources
### Graphite Poller (Bareos Contrib Repository)
#### Description
If you have a graphite node/cluster to monitor systems, we have a custom resource that installs the plugin and configures a cronjob (optionally and configurable) to simply send job statistics to the graphite cluster.

It could fall out of date as we have locked down to a specific commit but we can change that if users start to see issues with the one we are deploying by default.

__SPECIAL NOTE:__ This custom resource does not currently support Ubuntu `>= 16`. The custom resource will post an error in your chef-client log in those cases.
#### graphite_poller (Custom Resource)
