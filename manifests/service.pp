# Class: tomcat::service
#
class tomcat::service (
  $catalina_home,
  $catalina_base,
  $tomcat_user
) {

  file { '/etc/init.d/tomcat':
    ensure  => present,
    content => template('tomcat/tomcat.init.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0555'
  }

  service { 'tomcat':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    require   => File['/etc/init.d/tomcat']
  }
}
