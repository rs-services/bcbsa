name             'bw-tc-server'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures bw-tc-server'
long_description 'Installs/Configures bw-tc-server'
version          '1.0.0'

depends 'marker'

recipe 'bw-tc-server::install_tc_server', 'Installs TC Server 2.9'
recipe 'bw-tc-server::install_liferay_server', 'Installs liferay tomcat server on tc server'

attribute 'bw-tc-server/max_java_heap_size',
  :display_name => 'TC Server Max Heap Size',
  :description => 'Max Heap Size setting (1024M , 2G , 256K)',
  :type => 'string',
  :required => 'recommended',
  :default => '1024M',
  :recipes => ['bw-tc-server::install_liferay_server']

attribute 'bw-tc-server/min_java_heap_size',
  :display_name => 'TC Server Min Heap Size',
  :description => 'Max Heap Size setting (1024M , 2G , 256K)',
  :required => 'recommended',
  :type => 'string',
  :default => '512M',
  :recipes => ['bw-tc-server::install_liferay_server']

attribute 'bw-tc-server/database_ip',
  :display_name => 'Database IP or Hostname',
  :description => 'Liferay Database IP or Hostname',
  :required => 'recommended',
  :type => 'string',
  :recipes => ['bw-tc-server::install_liferay_server']

attribute 'bw-tc-server/database_user',
  :display_name => 'Database Username',
  :description => 'Liferay Database Username',
  :required => 'recommended',
  :type => 'string',
  :recipes => ['bw-tc-server::install_liferay_server']

attribute 'bw-tc-server/database_password',
  :display_name => 'Database Password',
  :description => 'Liferay Database Password',
  :required => 'recommended',
  :type => 'string',
  :recipes => ['bw-tc-server::install_liferay_server']
