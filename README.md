Description
===========

Installs TeXLive including many packages of TeX systems

Requirements
============

## Platform

* Linux (I'd tested on CentOS 6.3)

This cookbook needs 4GB+ disk space to install TeXLive.

Attributes
==========

* `node['texlive']['location']` - Location for install
  Default: "/usr/local/texlive/"

* `node['texlive']['version']` - Texlive version to install
  Default: "2018"

* `node['texlive']['netinstall']` - Location of network install download.
  Default: "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"

* `node['texlive']['localinstall']` - Location of extracted install files.  Uses this instead of netinstall if specified
  Default: N/A

* `node['texlive']['removeyuminstall']` -  If set to true it will remove the old yum version first
  Default: N/A

* `node['texlive']['timeout']` - Timeout for TeXLive installer.
  Default settings are 1800 (30min).

Usage
=====

Simply include the `texlive` and the TeXLive will be installed to your system.
