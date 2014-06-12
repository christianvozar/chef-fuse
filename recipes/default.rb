# Author:: Christian Vozar <christian@rogueethic.com>
# Cookbook Name:: fuse
# Recipe:: default
#
# Copyright 2014, Rogue Ethic, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'apt'
include_recipe 'build-essential'

case node['platform_family']
when 'debian'
  %w{ mime-support libcurl4-openssl-dev libxml2-dev }.each do |dependencies|
  package dependencies
end
when 'rhel'
  %w{ openssl-devel libxml2-devel curl-devel }.each do |dependencies|
  package dependencies
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/fuse-#{node['fuse']['version']}.tar.gz" do
  checksum node['fuse']['checksum']
  source "http://surfnet.dl.sourceforge.net/project/fuse/fuse-2.X/#{node['fuse']['version']}/fuse-#{node['fuse']['version']}.tar.gz"
  mode '0644'
end

# Avoid overwriting FuSE libraries in /lib.
bash "Install FUSE v#{node['fuse']['version']}" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  if [ ! -f "/etc/ld.so.conf.d/libc.conf" ]; then echo "/usr/local/lib" > /etc/ld.so.conf.d/libc.conf; fi
  tar -zxvf fuse-#{node["fuse"]["version"]}.tar.gz
  (cd fuse-#{node["fuse"]["version"]} && ./configure)
  (cd fuse-#{node["fuse"]["version"]} && make && make install)
  EOF
  not_if "test -f /usr/local/lib/libfuse.so.#{node['fuse']['version']}"
end
