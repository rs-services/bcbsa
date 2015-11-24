
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

node.override['tcserver']['rpm_filename'] = 'vfabric-tc-server-standard-2.9.5-SR1.noarch.rpm'
node.override['tcserver']['rpm_url'] = 'http://download.gopivotal.com/tcserver/2.9.5/'
node.override['tcserver']['rpm_sum'] = '04a1ea0a1d62bbb9eab328b1789adb5205888d51'

include_recipe 'tc_server::default'
