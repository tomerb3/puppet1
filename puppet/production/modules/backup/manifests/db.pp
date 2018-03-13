define backup::db (
  $root_backup_folder
  ){
  $env_details = hiera_hash('environments')
  $env_name = downcase($name)
  $project_name = downcase($::project)
  case $env_details[$name]['require_backup'] {
    'yes': {
      notify { "${name}_backup_db":
        message => "Backing Env ${name} DB";
      }
      #set the next version
      if $env_details[$name]['version'] {
        $version = $env_details[$name]['version']
      }
      else {fail('The new environment version is not define')}
      notify { "${name}_var_db":
        message => "Backing Env ${name} DB version ${version}";
      }
      #Detecting the the SQL server host name
		  if $env_details[$name]['DB_Server'] {
		    $db_host = $env_details[$name]['DB_Server']
		  }
		  elsif hiera('DB_Server') {
		    $db_host = hiera('DB_Server')
		  }
		  else {fail('The DB_Server hostname is not provided')}
      notify { "${name}_ser_db":
        message => "Backing Env ${name} DB server ${db_host}";
      }
      if $env_details[$name]['db_list'] {
        file {
	        "${root_backup_folder}\\${name}":
	          ensure  => directory;
	        "${root_backup_folder}\\${name}\\before_updating_to_${version}\\db":
	          ensure  => directory;        
        }
        #getting the DB list
        if $env_details[$name]['db_list']{
          $db_list = $env_details[$name]['db_list']
        }
        else {fail('The db_list is empty')}
        #Runuing the backup via sqlcmd
        $db_list.each |String $db |{
          $query = "\"BACKUP DATABASE [${db}] TO  DISK = N'${root_backup_folder}\\${name}\\before_updating_to_${version}\\db\\${db}.bak' WITH NOFORMAT, NOINIT,  NAME = N'${db} Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION\""
          notify { "${db}_backup_q":
            message => "using ${query}";
            "${db}_backup_timeout":
              message => "The backup have up to 600 Sec (10 min) to finish";
          }
          exec {
	          "run_backup_${db}" :
	            command     => "invoke-sqlcmd -ErrorAction Stop -serverinstance ${db_host} -database master -Query ${query} -QueryTimeout 0 -OutputSqlErrors 1",
	            timeout     => 600,
	            logoutput   => true,
	            creates     => "${root_backup_folder}\\${name}\\before_updating_to_${version}\\db\\${db}.bak",
	            provider    => powershell;    
	        }
        }
      }
    }
    default : { 
      notify { "${name}_no_backup":
        message => "Env ${name} do not require backup";
      }
    }
  }
}