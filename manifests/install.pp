# Class: tomcat::install
#
# This class installs an Apache Tomcat binary distribution from local or
# remote source.
#
# Parameters:
#
#  [*source*]
#    The Tomcat distribution file location. This class supports local files
#    and puppet://, http://, https://, and ftp:// URLs. If undefined, this
#    class will attempt to download a distribution from the usual location.
#
#  [*version*]
#    The Tomcat version to install.
#
#  [*install_dir*]
#    The installation directory managed by this class. Distributions are
#    unpacked to "${install_dir}/releases" and the most recently installed
#    release is symlinked from "$current_dir". The directory MUST exist prior
#    to invocation; this class WILL NOT create it.
#
#  [*current_dir*]
#    This is a symlink to the most recently installed version. The symlink
#    MUST NOT exist prior to invocation (but any intermediaries must); this
#    class WILL create it.
#
class tomcat::install (
  $source,
  $version,
  $install_dir,
  $current_dir,
  $auto_upgrade,
) {

  $releases_dir = "${install_dir}/releases"

  file { $releases_dir:
    ensure => directory
  }

  $package_name = "apache-tomcat-${version}"
  $package_file = "${package_name}.tar.gz"
  if $source {
    $real_source = $source
  } else {
    # FIXME: Enforce (implied) major version == '7'
    $real_source = "http://archive.apache.org/dist/tomcat/tomcat-7/v${version}/bin/${package_file}"
  }

  staging::deploy { $package_file:
    source  => $real_source,
    target  => $releases_dir,
    require => File[$releases_dir]
  }

  file { $current_dir:
    ensure  => link,
    target  => "${releases_dir}/${package_name}",
    replace => $auto_upgrade,
    require => Staging::Extract[$package_file],
    notify  => Class['tomcat::service']
  }
}
