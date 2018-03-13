# Class: prerequisite
# ===========================
#
# Full description of class prerequisite here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
# Authors
# -------
#
# Author Name <oded.simon@sapiens.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class prerequisite {
  require prerequisite::params

  $java_install_path = "jdk1.${::prerequisite::params::major_version}.0_${::prerequisite::params::minor_version}"
#  notify {
#    'java_url':
#      name    => "the path to java install: ${::prerequisite::params::java_url}",
#      message => $::prerequisite::params::java_url;
#    'java_major_version':
#      name    => "java major version: ${::prerequisite::params::major_version}",
#      message => $::prerequisite::params::major_version;   
#    'java_minor_version':
#      name    => "java minor version: ${::prerequisite::params::minor_version}",
#      message => $::prerequisite::params::minor_versionn;
#    'java_install_path':
#      name    => "java minor version: ${java_install_path}",
#      message => $java_install_path;
#  }
    
#  
#  case $::facts['kernel'] {
#   'windows' : {
#      exec { 
#        'jdk_64':
#	        command => "$::prerequisite::params::java_url\\jdk-${::prerequisite::params::major_version}u${::prerequisite::params::minor_version}-windows-x64.exe /s ADDLOCAL=\"ToolsFeature\"",
#	        unless  => "[System.IO.File]::Exists(\"C:\Program Files\Java\\$java_install_path\")";
#	      'jdk_32':
#          command => "$::prerequisite::params::java_url\\jdk-${::prerequisite::params::major_version}u${::prerequisite::params::minor_version}-windows-i586.exe /s ADDLOCAL=\"ToolsFeature\",
#          unless  => "[System.IO.File]::Exists(\"C:\Program Files (x86)\Java\\$java_install_path\")";
#      }
#    }
#    default : {fail ("unsupported platform ${$::facts['kernel']}") }
#  }

}
