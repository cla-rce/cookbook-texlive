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


#remote_file node["texlive"]["filename"] do
#  source node["texlive"]["dvd_url"]
#  #checksum node["texlive"]["dvd_checksum"]
#  path "#{Chef::Config[:file_cache_path]}/#{node["texlive"]["filename"]}"
#  backup false
#  not_if {::File.exists?(node["texlive"]["location"])}
    
#  notifies :create, "template[/tmp/texlive.profile]", :immediately
#  notifies :run, "script[install-texlive]", :immediately
#end

yum_package 'perl-Digest-MD5' do
  action :install
end
#wget

ark 'texlive' do
  url "#{node['texlive']['netinstall']}"
  path "#{Chef::Config[:file_cache_path]}/#{node["texlive"]["filename"]}"
  action :put
  notifies :create, "template[/tmp/texlive.profile]", :immediately
  
  
end  

template "/tmp/texlive.profile" do
  source 'texlive.profile.erb'
  variables(location: node['texlive']['location'],
            version: node['texlive']['version'])
  notifies :run, "script[install-texlive]", :immediately
end
#default['texlive']['location']

#cookbook_file "/tmp/texlive.profile" do
#  source "texlive.profile"
#  action :nothing
#end

script "install-texlive" do
  interpreter "bash"
  #action :nothing
  timeout node['texlive']['timeout'].to_i
  flags "-e"
  code <<-EOH
     cd #{Chef::Config[:file_cache_path]}/#{node["texlive"]["filename"]}/texlive
     ./install-tl --profile /tmp/texlive.profile -logfile /tmp/install-tl.log
  EOH
end

#trap 'umount /mnt' EXIT
#    mount -oloop=/dev/loop0 #{Chef::Config[:file_cache_path]}/#{node["texlive"]["filename"]} /mnt &&
#    /mnt/install-tl --profile /tmp/texlive.profile
#    rm -f installation.profile install-tl.log 

#file "texlive-cleanup" do
#  path "#{Chef::Config[:file_cache_path]}/#{node["texlive"]["filename"]}"
#  action :delete
#  backup false
#end

#file "texlive-profile-cleanup" do 
#  path "/tmp/texlive.profile"
#  action :delete
#end
