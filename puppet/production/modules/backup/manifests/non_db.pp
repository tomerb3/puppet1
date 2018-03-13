#running the backup per env
define backup::non_db (
  $root_backup_folder
  ){
  $env_details = hiera_hash('environments')
  $env_name = downcase($name)
  $project_name = downcase($::project)
  case $env_details[$name]['require_backup'] {
    'yes': {
      notify { "${name}_backup":
        message => "Backing Env ${name} binaries";
      }
      #set the next version
      if $env_details[$name]['version'] {
        $version = $env_details[$name]['version']
      }
      else {fail('The new environment version is not define')}
      file {
        "${root_backup_folder}\\${name}":
          ensure  => directory;
        "${root_backup_folder}\\${name}\\before_updating_to_${version}":
          ensure  => directory;        
        }
      #set the source root path
      $tomcat_base = hiera('Base_Deployment_app_server')
      $bl_base = hiera('Base_Deployment_BL')
      #Set the SL sources
      if $env_details[$name]['sl'] {
        $sl_port = $env_details[$name]['sl']['port']
      if $env_details[$name]['sl']['target_war_name'] {
        $sl_war_name = $env_details[$name]['sl']['target_war_name'] 
      }
      else { $sl_war_name = "${project_name}_sl_${env_name}" }
      $source_sl_war = "${tomcat_base}\\Tomcat${sl_port}\\webapps\\${sl_war_name}.war"
      #set the SL external conf source
      $source_sl_conf = "${tomcat_base}\\Tomcat${sl_port}\\conf\\ALIS"
      file {
        "${root_backup_folder}\\${name}\\before_updating_to_${version}\\sl":
          ensure  => directory;
        "${root_backup_folder}\\${name}\\before_updating_to_${version}\\sl\\${sl_war_name}.war":
          ensure  => present,
          source  => $source_sl_war;
        "${root_backup_folder}\\${name}\\before_updating_to_${version}\\sl\\conf":
          ensure  => directory,
          source  => $source_sl_conf,
          recurse   => true;
        }
      }     

      #Set the PL sources
      if $env_details[$name]['pl'] {
        $pl_port = $env_details[$name]['pl']['port']
	      if $env_details[$name]['pl']['target_war_name'] {
	        $pl_war_name = $env_details[$name]['pl']['target_war_name'] 
	      }
	      else { $pl_war_name = "${project_name}_pl_${env_name}" }
	      $source_pl_war = "${tomcat_base}\\Tomcat${pl_port}\\webapps\\${pl_war_name}.war"
	      #set the PL external conf source
	      $source_pl_conf = "${tomcat_base}\\Tomcat${pl_port}\\conf\\ALIS"
        file {
         "${root_backup_folder}\\${name}\\before_updating_to_${version}\\pl":
          ensure  => directory;
        "${root_backup_folder}\\${name}\\before_updating_to_${version}\\pl\\${pl_war_name}.war":
          ensure  => present,
          source  => $source_pl_war;
        "${root_backup_folder}\\${name}\\before_updating_to_${version}\\pl\\conf":
          ensure  => directory,
          source  => $source_pl_conf,
          recurse   => true;
        }        
      }

      #Set the BL source
      if $env_details[$name]['bl'] {
        $source_bl = "${bl_base}\\${name}"
        file {
	        "${root_backup_folder}\\${name}\\before_updating_to_${version}\\bl":
	          ensure  => directory,
	          source  => $source_bl,
	          recurse   => true;       
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