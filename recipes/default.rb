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

installfolder = ""
installoption = ""


script "install-texlive" do
  interpreter "bash"
  action :nothing
  
  if node['texlive']['localinstall'].nil?
    installfolder = "#{Chef::Config[:file_cache_path]}/#{node['texlive']['version']}"
    notifies :put, "ark[texlive]", :immediately
  else
    installfolder = "#{node['texlive']['localinstall']}"
    installoption = "-no-verify-downloads"
  end
  timeout node['texlive']['timeout'].to_i
  flags "-e"
  cwd installfolder
  code <<-EOH
     cd #{installfolder}
     ./install-tl --profile /tmp/texlive.profile #{installoption} -logfile /tmp/install-tl.log
  EOH
   
  notifies :delete, "file[texlive-profile-cleanup]"
end

file "texlive-profile-cleanup" do 
  path "/tmp/texlive.profile"
  action :nothing
end

#verify texlive version?
#(`latex -version`).split("\n")[0].gsub(/\(|\)/,'').split(' ')[4]


ruby_block "texlive_list_for_removal" do
  block do
    packagestring = `rpm -qa texlive*`
    node.run_state['remove_packages'] = packagestring.split("\n")
  end
  only_if { node['texlive']['removeyuminstall'] }
end

package "remove yum texlive" do
  package_name lazy { node.run_state['remove_packages'] }
  action :remove
  only_if { node.run_state['remove_packages'] }
end

template "/tmp/texlive.profile" do
  source 'texlive.profile.erb'
  variables(location: node['texlive']['location'],
            version: node['texlive']['version'])
  if platform?("redhat", "centos", "fedora") 
    notifies :install, "yum_package[perl-Digest-MD5]", :before
    notifies :remove, 'package[remove yum texlive]', :before
    notifies :install, "yum_package[fontconfig]", :before
  else
    notifies :install, 'apt_package[libfontconfig]', :before
  end
  
  if node['texlive']['localinstall'].nil?
    installfolder = "#{Chef::Config[:file_cache_path]}/#{node['texlive']['version']}"
  else
    installfolder = "#{node['texlive']['localinstall']}"
    #install can fail because of gpg if install files not writable
    installoption = "-no-verify-downloads"
    
  end
  notifies :run, "script[install-texlive]", :immediately
  
  #check to see if texlive is installed already
  not_if { ::File.exist?("#{node['texlive']['location']}/#{node['texlive']['version']}/release-texlive.txt") }
end

#texlive prerequisite 

apt_package ['libfontconfig'] do
  action :nothing
end

yum_package ['fontconfig'] do
  action :nothing
end

yum_package ['perl-Digest-MD5'] do
  action :nothing
end

#download network installer and start install
ark 'texlive' do
  url "#{node['texlive']['netinstall']}"
  path "#{Chef::Config[:file_cache_path]}/#{node["texlive"]["version"]}"
  installfolder = "#{Chef::Config[:file_cache_path]}/#{node['texlive']['version']}/texlive"
  notifies :run, "script[install-texlive]", :immediately
  action :nothing
end  
