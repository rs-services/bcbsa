
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
    ENV['JAVA_HOME'] = '/usr/java/jdk1.8.0_45'
  end
end

execute 'move-liferay-webapp-files' do
  command 'cp -R /opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/webapps/* /opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/webapps/'
  #cwd '/opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/ '
  user 'liferay'
end

execute 'move-liferay-ext-files' do
  command 'cp -R /opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/webapps/lib/ext /opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/lib/'
  #cwd '/opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/webapps/lib/ '
  user 'liferay'
end

execute 'move-liferay-jar-files' do
  command 'cp /opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/webapps/lib/ext/*.jar /opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/lib/'
  #cwd '/opt/vmware/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/webapps/lib/ext/ '
  user 'liferay'
end

execute 'start-tc-liferay-server' do
  command './tcruntime-ctl.sh start'
  cwd '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/bin'
  user 'liferay'
end
