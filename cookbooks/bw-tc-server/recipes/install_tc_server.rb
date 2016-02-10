
# Cookbook Name:: bw-tc-server
# Recipe:: install_tc_server
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

yum_package 'java'

user 'liferay' do
  comment 'liferay and tcserver user'
  home '/opt/vmware'
  shell '/bin/bash'
end

group 'liferay' do
  action :create
  members 'liferay'
  append true
end

directory '/opt/vmware/' do
  recursive true
  mode 0755
  owner 'liferay'
  group 'liferay'
  action :create
end

remote_file '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1.tar.gz' do
  source 'http://download.gopivotal.com/tcserver/2.9.5/vfabric-tc-server-standard-2.9.5.SR1.tar.gz'
  owner 'liferay'
  group 'liferay'
end

execute 'extract_tc_server' do
  command 'tar xzvf vfabric-tc-server-standard-2.9.5.SR1.tar.gz'
  cwd '/opt/vmware'
  user 'liferay'
  not_if { File.exist?('/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/README.txt') }
end

ruby_block 'set-env-java-home' do
  block do
    ENV['JAVA_HOME'] = '/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0'
    #ENV['JAVA_HOME'] = '/usr/java/jdk1.8.0_45'
  end
end

execute 'create-liferay-instance' do
  command './tcruntime-instance.sh create LIFERAY-INSTANCE-1'
  cwd '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1'
  user 'liferay'
  not_if { File.exist?('/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1') }
end

execute 'start-tc-server-validate' do
  command './tcruntime-ctl.sh start'
  cwd '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/bin'
  user 'liferay'
end

execute 'stop-tc-server-validate' do
  command './tcruntime-ctl.sh stop'
  cwd '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1/LIFERAY-INSTANCE-1/bin'
  user 'liferay'
end

execute 'prepare-tc-server-for-liferay-tomcat' do
  command 'rm -rf LIFERAY-INSTANCE-1/webapps/ROOT'
  cwd '/opt/vmware/vfabric-tc-server-standard-2.9.5.SR1'
  user 'liferay'
end
