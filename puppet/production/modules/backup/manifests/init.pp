# Class: backup
# ===========================

class backup {
  #Cheking the OS type and allowing only working on windows OS
  case $::kernel {
    'windows' : {
      notify { 'In Backup module':
        message => 'this is the alis backup init file';
      }
      $env_details = hiera_hash('environments')
		  #Set the root backup folder
		  if hiera('BackupFolder') {
		    $destination_dir = hiera('BackupFolder')
		  }
		  else {fail('The BackupFolder is not define')}
		  
		  file {
		    $destination_dir :
		      ensure => directory;
		  }
      if $env_details {
        $envs = keys($env_details)
        if $envs {
          #debug
          notify {
            "${envs}_backup" :
               message => "working on ENV: ${envs}";
          }
          case $::role {
            'APPLICATION': {
              backup::non_db { $envs:
                root_backup_folder => $destination_dir
              }    
            }
            'DB':{
              notify {
                "${envs}_DB_backup" :
                  message => "Backup DB on ENV: ${envs}";
              }
              backup::db { $envs:
                root_backup_folder => $destination_dir
              }
            }
            default: {
              fail("Unknown server role ${::role}")
            }
          }
        }
      }
    }
    default : {fail ("unsupported platform ${kernel}") }
  }

}
