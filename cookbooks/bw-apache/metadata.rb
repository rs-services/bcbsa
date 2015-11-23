name             'bw-apache'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures bw-apache'
long_description 'Installs/Configures bw-apache'
version          '0.1.0'

depends 'apache2'
depends 'marker'

recipe 'bw-apache::install', 'installs apache web server'
recipe 'bw-apache::enable-mod-ajp', 'enabled the mod_proxy_ajp'
recipe 'bw-apache::configure-ajp', 'configure mod_proxy_ajp to proxy to tc-server'
