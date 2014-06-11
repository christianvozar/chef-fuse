name             'chef-fuse'
maintainer       'Rogue Ethic, LLC.'
maintainer_email 'support@rogueethic.com'
license          'Apache v2.0'
description      'Installs FUSE, Filesystem in Userspace.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

# Cookbook dependancies
%w{ apt build-essential }.each do |cookbooks|
  depends cookbooks
end

# Operating systems supported
%w{ debian ubuntu redhat fedora }.each do |os|
  supports os
end
