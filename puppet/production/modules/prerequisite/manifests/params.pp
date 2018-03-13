# call the params from hiera
class prerequisite::params {
  $prerequisite = hiera_hash('prerequisite')
  $major_version = $prerequisite['java']['major_version']
  $minor_version = $prerequisite['java']['minor_version']
  case $::facts['kernel'] {
    'windows' : {
      $java_url = $prerequisite['java']['win_oracle_path']
    }
    default : {fail ("unsupported platform ${$::facts['kernel']}") }
  }
}