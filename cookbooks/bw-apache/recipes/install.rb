# Cookbook Name:: bw-apache
# Recipe:: install
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

template '/etc/yum.repos.d/epel-httpd24.repo' do
  source 'epel-httpd24.repo.erb'
end

node.override['apache']['version'] = '2.4'

include_recipe 'apache2::default'

execute 'update-to-httpd24' do
  command 'yum -y install httpd24'
end

execute 'start-httpd24' do
  command 'service httpd24-httpd start'
end

template '/etc/httpd/sites-available/apache-frontend' do
  source 'apache-frontend.conf.erb'
  variables(
    :server_name => 'localhost',
    :liferay_server => '127.0.0.1',
    :liferay_port => '8000'
  )
end
