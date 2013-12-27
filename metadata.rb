name             'web'
maintainer       'Pirate Dunbar'
maintainer_email 'yarr@piratedunbar.com'
license          'All rights reserved'
description      'Installs/Configures web'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.9'

depends 'apt'
depends 'git'
depends 'subversion'
depends 'apache2'
depends 'nginx'
