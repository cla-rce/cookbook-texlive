#
# Cookbook Name:: texlive
# Recipe:: default
#
# Copyright 2012, Takeshi KOMIYA
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
#

remote_file "texlive2016.iso" do
  source node["texlive"]["dvd_url"]
  checksum node["texlive"]["dvd_checksum"]
  path "#{Chef::Config[:file_cache_path]}/texlive2016.iso"
  backup false
  not_if {::File.exists?("/usr/local/texlive/2016")}
  notifies :create, "cookbook_file[/tmp/texlive.profile]", :immediately
  notifies :run, "script[install-texlive]", :immediately
end

cookbook_file "/tmp/texlive.profile" do
  source "texlive.profile"
  action :nothing
end

script "install-texlive" do
  interpreter "bash"
  action :nothing
  timeout node['texlive']['timeout'].to_i
  flags "-e"
  code <<-EOH
    trap 'umount /mnt' EXIT
    mount -oloop=/dev/loop0 #{Chef::Config[:file_cache_path]}/texlive2016.iso /mnt &&
    /mnt/install-tl --profile /tmp/texlive.profile
    rm -f installation.profile install-tl.log 
  EOH
end

file "texlive-cleanup" do
  path "#{Chef::Config[:file_cache_path]}/texlive2016.iso"
  action :delete
  backup false
end

file "texlive-profile-cleanup" do 
  path "/tmp/texlive.profile"
  action :delete
end
