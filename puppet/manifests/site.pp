node default {
  include hello
  file { "/tmp/hello" :
    ensure => present,
    content => "hello !!!"
  }
}
