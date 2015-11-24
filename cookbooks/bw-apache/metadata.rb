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

attribute 'bw-apache/server_name',
  :display_name => 'Server Name',
  :description => 'Apache Server Name',
  :type => 'string',
  :required => 'recommended',
  :default => 'localhost'

attribute 'bw-apache/liferay_server',
  :display_name => 'Liferay Application Server',
  :description => 'Hostname or ip of the Liferay Application Server',
  :type => 'string',
  :required => 'recommended',
  :default => '127.0.0.1'

attribute 'bw-apache/doc_root',
  :display_name => 'Apache DocumentRoot',
  :description => 'DocumentRoot path for apache frontend server',
  :type => 'string',
  :required => 'recommended',
  :default => '/var/www/html'

attribute 'bw-apache/liferay_port',
  :display_name => 'Liferay Application Port',
  :description => 'Liferay Application Port',
  :type => 'string',
  :required => 'recommended',
  :default => '8000'
