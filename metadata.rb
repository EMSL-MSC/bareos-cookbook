name              'bareos'
maintainer        'Ian Smith - Gitbytes'
maintainer_email  'gitbytes@gmail.com'
license           'MIT'
description       'Deploy and manage Bareos (https://www.bareos.org) with Chef'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url        'https://github.com/EMSL-MSC/bareos-cookbook/issues'
source_url        'https://github.com/EMSL-MSC/bareos-cookbook.git'
version           '1.0.1'

chef_version      '~> 14.0'

supports          'debian', '>= 8'
supports          'ubuntu', '>= 14'
supports          'centos', '>= 6'
