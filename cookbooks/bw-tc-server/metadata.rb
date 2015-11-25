name             'bw-tc-server'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures bw-tc-server'
long_description 'Installs/Configures bw-tc-server'
version          '0.1.0'

depends 'marker'

recipe 'bw-tc-server::install_tc_server', 'Installs TC Server 2.9'
recipe 'bw-tc-server::install_liferay_server', 'Installs liferay tomcat server on tc server'
