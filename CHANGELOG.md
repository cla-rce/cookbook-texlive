## 0.3.0:

* Updated to support newer version and make everything attribute based so new versions can be used without code changes
* Now only does network install or install from extracted dvd image.  Defaults to network install unless ['texlive']['localinstall'] is specified.
* Can remove old yum based version if attribute ['texlive']['removeyuminstall'] is set to true

## 0.2.1:

* Update ISO image to texlive2014-20140525.iso

## 0.2.0:

* Add configuration: node['texlive']['timeout']

## 0.1.0:

* Initial release of texlive
