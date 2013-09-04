# Class: tomcat
#
class tomcat(
  $source       = undef,
  $version      = '7.0.42',
  $install_dir  = '/opt/tomcat',
  $instance_dir = '/var/tomcat',
  $auto_upgrade = false,
  $owner        = 'tomcat',
  $group        = 'tomcat',
  $hostname     = 'localhost',
  $jre_home     = '/etc/alternatives/jre',
  $java_opts    = ''
) {

  $current_dir = "${install_dir}/current"

  class { 'tomcat::install':
    source       => $source,
    version      => $version,
    install_dir  => $install_dir,
    current_dir  => $current_dir,
    auto_upgrade => $auto_upgrade
  }

  class { 'tomcat::config':
    catalina_home => $current_dir,
    catalina_base => $instance_dir,
    owner         => $owner,
    group         => $group,
    hostname      => $hostname,
    jre_home      => $jre_home,
    java_opts     => $java_opts
  }

  class { 'tomcat::service':
    catalina_home => $current_dir,
    catalina_base => $instance_dir,
    tomcat_user   => $owner
  }

  anchor { 'tomcat::begin': }
  anchor { 'tomcat::end': }

  Anchor['tomcat::begin'] ->
  Class['tomcat::install'] ->
  Class['tomcat::config'] ->
  Class['tomcat::service'] ->
  Anchor['tomcat::end']
}
