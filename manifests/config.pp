# Class: tomcat::config
#
class tomcat::config (
  $catalina_home,
  $catalina_base,
  $catalina_opts,
  $owner,
  $group,
  $hostname,
  $jre_home,
  $java_opts
) {

  $bin_dir     = "${catalina_base}/bin"
  $conf_dir    = "${catalina_base}/conf"
  $lib_dir     = "${catalina_base}/lib"
  $logs_dir    = "${catalina_base}/logs"
  $temp_dir    = "${catalina_base}/temp"
  $webapps_dir = "${catalina_base}/webapps"
  $work_dir    = "${catalina_base}/work"

  File {
    ensure => present,
    owner  => $owner,
    group  => $group,
    mode   => '0444',
    notify => Class['tomcat::service']
  }

  file { $bin_dir:
    ensure => directory,
    mode   => '0555'
  }

  file { "${bin_dir}/setenv.sh":
    content => template('tomcat/setenv.sh.erb'),
    mode    => '0555',
    require => File[$bin_dir]
  }

  file { $conf_dir:
    ensure => directory,
    mode   => '0555'
  }

  file { "${conf_dir}/catalina.policy":
    source  => 'puppet:///modules/tomcat/catalina.policy',
    require => File[$conf_dir],
  }

  file { "${conf_dir}/catalina.properties":
    source  => 'puppet:///modules/tomcat/catalina.properties',
    require => File[$conf_dir],
  }

  file { "${conf_dir}/context.xml":
    source  => 'puppet:///modules/tomcat/context.xml',
    require => File[$conf_dir],
  }

  file { "${conf_dir}/logging.properties":
    source  => 'puppet:///modules/tomcat/logging.properties',
    require => File[$conf_dir],
  }

  file { "${conf_dir}/server.xml":
    content => template('tomcat/server.xml.erb'),
    require => File[$conf_dir],
  }

  file { "${conf_dir}/tomcat-users.xml":
    source  => 'puppet:///modules/tomcat/tomcat-users.xml',
    require => File[$conf_dir],
  }

  file { "${conf_dir}/web.xml":
    source  => 'puppet:///modules/tomcat/web.xml',
    require => File[$conf_dir],
  }

  file { "${conf_dir}/Catalina":
    ensure  => directory,
    mode    => '0555',
    require => File[$conf_dir]
  }

  file { "${conf_dir}/Catalina/${hostname}":
    ensure  => directory,
    mode    => '0755',
    require => File["${conf_dir}/Catalina"]
  }

  file { $lib_dir:
    ensure => directory,
    mode   => '0555'
  }

  file { $logs_dir:
    ensure => directory,
    mode   => '0755'
  }

  file { $temp_dir:
    ensure => directory,
    mode   => '0755'
  }

  file { $webapps_dir:
    ensure => directory,
    mode   => '0755'
  }

  file { $work_dir:
    ensure => directory,
    mode   => '0755'
  }
}
