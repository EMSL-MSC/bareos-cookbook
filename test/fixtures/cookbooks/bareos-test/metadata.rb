name              'bareos-test'
maintainer        'Ian Smith - Gitbytes'
maintainer_email  'gitbytes@gmail.com'
license           'MIT'
description       'Test cookbook for bareos-cookbook (https://www.bareos.org) with Chef'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url        'https://github.com/EMSL-MSC/bareos-cookbook/issues'
source_url        'https://github.com/EMSL-MSC/bareos-cookbook.git'
version           '0.0.1'

chef_version      '~> 14'

supports          'debian', '>= 8'
supports          'ubuntu', '>= 14'
supports          'centos', '>= 6'

depends           'postgresql', '~> 7.0'
depends           'mysql', '~> 8.0'
depends           'yum-epel'
depends           'chef-sugar'
depends           'chef-vault'
depends           'bareos'
