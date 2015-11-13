class hello {
  file {
    "/tmp/helloworld":
      ensure => present,
      source => "puppet:///modules/hello/helloworld";
  }
}
