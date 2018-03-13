# Author:: David J Felix
# Copyright:: Copyright (c) 2015 David J Felix
# License:: MIT

class notepad_plus_plus (
  $destination_directory='C:\ProgramData\PuppetLabs\puppet\etc',
  $destination_file='npp.exe',
  $proxy_address='',
  $proxy_user='',
  $proxy_password='',
  $is_password_secure=false
) {
  $npp_details = hiera('npp')
  $npp_url = $npp_details['npp_url']
  $npp_version = $npp_details['npp_version']

#  notify {
#    'npp_url':
#      message => "the npp_url is: ${npp_url}";
#    'npp_version':
#      message => "the npp_version is: ${npp_version}";
#  }
  case $::osfamily {
    'Windows': {
      download_file { 'npp.exe':
        url                   => $npp_url,
        destination_directory => $destination_directory,
        destination_file      => $destination_file,
        proxy_address         => $proxy_address,
        proxy_user            => $proxy_user,
        proxy_password        => $proxy_password,
        is_password_secure    => $is_password_secure 
      }
      package { 'npp.exe':
        ensure          => present,
        source          => "${destination_directory}\\${destination_file}",
        install_options => ['/S'],
        require         => Download_file['npp.exe']
      }
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }
}
