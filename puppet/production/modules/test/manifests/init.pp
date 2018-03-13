# Class: test
# ===========================

class test {
  require test::params
  case $::kernel {
    'windows' : {
      notify { 'in_test windows v7':
        message => 'this is the test init file';
      }
      if $::test::params::env_details {
        $envs = keys($::test::params::env_details)
        if $envs {
          notify {
            "${envs}_DB_1111111111111_update" :
              message => "run  test  for env: ${envs}";
          }
          test::runsql2 { $envs: }
        }
      }
    }
    default : {fail ("unsupported platform ${kernel}") }
  }
}
