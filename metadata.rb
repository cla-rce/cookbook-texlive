name             "cookbook-texlive"
maintainer       "Takeshi KOMIYA"
maintainer_email "i.tkomiya@gmail.com"
license          "Apache 2.0"
description      "Installs TeXLive"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.2"

%w{ fedora redhat centos ubuntu debian amazon }.each do |os|
  supports os
end

depends 'ark'

source_url "https://github.com/cla-rce/cookbook-texlive" if respond_to?(:source_url)
issues_url "https://github.com/cla-rce/cookbook-texlive/issues" if respond_to?(:issues_url)