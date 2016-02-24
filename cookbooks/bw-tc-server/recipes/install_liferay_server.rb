
# Cookbook Name:: bw-tc-server
# Recipe:: install_liferay_server
#
# Copyright (C) 2015 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
marker 'recipe_start'

marker 'recipe_start_rightscale' do
  template 'rightscale_audit_entry.erb'
end

yum_package 'unzip'

remote_file '/opt/vmware/liferay-portal-tomcat-6.2-ce-ga4.zip' do
  source 'https://s3.amazonaws.com/passfw/liferay-portal-tomcat-6.2-ce-ga4.zip'
  owner 'liferay'
  group 'liferay'
end

execute 'extract_tc_server' do
  command 'unzip -q liferay-portal-tomcat-6.2-ce-ga4.zip'
  cwd '/opt/vmware'
  user 'liferay'
  not_if { File.exist?('/opt/vmware/liferay-portal-6.2-ce-ga4/readme.html') }
end

ruby_block 'set-env-java-home' do
  block do
    ENV['JAVA_HOME'] = '/usr/java/jdk1.7.0_79'
  end
end

execute 'move-liferay-webapp-files' do
  command 'cp -R /opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/webapps/* /opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/webapps/'
  # cwd '/opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/ '
  user 'liferay'
end

execute 'move-liferay-ext-files' do
  command 'cp -R /opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/lib/ext /opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/lib/'
  # cwd '/opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/lib/ '
  user 'liferay'
end

execute 'move-liferay-jar-files' do
  command 'cp /opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/lib/ext/*.jar /opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/lib/'
  # cwd '/opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/lib/ext/ '
  user 'liferay'
end

template '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/bin/setenv.sh' do
  source 'setenv.erb'
  variables(
    :max_java_heap_size => "#{node['bw-tc-server']['max_java_heap_size']}",
    :min_java_heap_size => "#{node['bw-tc-server']['min_java_heap_size']}"
  )
end

template '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/webapps/ROOT/WEB-INF/classes/portal-ext.properties' do
  source 'portal-ext.properties.erb'
  variables(
    :database_ip => "#{node['bw-tc-server']['database_ip']}",
    :database_user => "#{node['bw-tc-server']['database_user']}",
    :database_password => "#{node['bw-tc-server']['database_password']}"
  )
end

execute 'update-protocol-to-ajp' do
  command "sed -i 's/org.apache.coyote.http11.Http11Protocol/AJP\\/1.3/g' /opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/conf/server.xml"
  user 'liferay'
end

file '/opt/vmware/liferay-portal-tomcat-6.2-ce-ga4.zip' do
  action :delete
end

file '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1.tar.gz' do
  action :delete
end

execute 'start-tc-liferay-server' do
  command 'export JAVA_HOME=/usr/java/jdk1.7.0_79 && ./tcruntime-ctl.sh start'
  cwd '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/bin'
  user 'liferay'
end
