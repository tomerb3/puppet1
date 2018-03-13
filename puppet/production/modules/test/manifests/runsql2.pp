define test::runsql2 {
  require test::params
  $env_details = hiera_hash('environments')
  }


$mq_type = hiera('MQ_type')

file { 'c:\temp2\test6.txt':
   ensure    => present;
}




file { 'c:\temp2\test5.txt':
   ensure    => present,
   content   => template("test/test.erb");
}

