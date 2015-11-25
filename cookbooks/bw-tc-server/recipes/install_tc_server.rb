
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
yum_package 'java'

directory '/opt/tc_server/' do
  recursive true
  mode 0644
  action :create
end

remote_file '/opt/tc_server/vfabric-tc-server-standard-2.9.5.SR1.tar.gz' do
  source 'http://download.gopivotal.com/tcserver/2.9.5/vfabric-tc-server-standard-2.9.5.SR1.tar.gz'
end

execute 'extract_tc_server' do
  command 'tar xzvf vfabric-tc-server-standard-2.9.5.SR1.tar.gz'
  cwd '/opt/tc_server'
  #not_if { File.exists?("/file/contained/in/tar/here") }
end

# directory '/usr/java' do
# end
#
# link '/usr/java/bin' do
#   to '/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.45-28.b13.el6_6.x86_64/jre/bin'
#   link_type :symbolic
# end
