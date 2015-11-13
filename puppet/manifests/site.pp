# /etc/puppet/manifests/site.pp

node default {
  file { "/tmp/hello" :
    ensure => present,
    content => "hello !!!"
  }
}
