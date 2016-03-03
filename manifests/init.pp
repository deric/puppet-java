# Class: java
# ===========================
#
class java(
  $distribution          = 'jdk',
  $version               = 'present',
  $package               = undef,
  $java_alternative      = undef,
  $java_alternative_path = undef,
  $source                = undef,
  $release               = 'java8',
  $repository            = undef,
  $accept_oracle_license = false,
  $set_oracle_default    = false,
) {

  include java::params

  validate_re($version, 'present|installed|latest|^[.+_0-9a-zA-Z:-]+$')

  if has_key($java::params::java, $distribution) {
    $default_package_name     = $java::params::java[$distribution]['package']
    $default_alternative      = $java::params::java[$distribution]['alternative']
    $default_alternative_path = $java::params::java[$distribution]['alternative_path']
    $java_home                = $java::params::java[$distribution]['java_home']
  } else {
    fail("Java distribution ${distribution} is not supported.")
  }

  $use_java_package_name = $package ? {
    undef   => $default_package_name,
    default => $package,
  }

  ## If $java_alternative is set, use that.
  ## Elsif the DEFAULT package is being used, then use $default_alternative.
  ## Else undef
  $use_java_alternative = $java_alternative ? {
    undef   => $use_java_package_name ? {
      $default_package_name => $default_alternative,
      default               => undef,
    },
    default => $java_alternative,
  }

  ## Same logic as $java_alternative above.
  $use_java_alternative_path = $java_alternative_path ? {
    undef   => $use_java_package_name ? {
      $default_package_name => $default_alternative_path,
      default               => undef,
    },
    default => $java_alternative_path,
  }

  $jre_flag = $use_java_package_name ? {
    /headless/ => '--jre-headless',
    default    => '--jre'
  }

  anchor { 'java::begin:': }
  ->
  class {'java::repo':
    repository => $repository,
  }
  ->
  anchor { 'java::package': }
  case $::osfamily {
    Debian: {
      # Needed for update-java-alternatives
      ensure_resource('package', ['java-common'],
        {'ensure' => present, 'require' => Anchor['java::package:']}
      )
      if ($distribution == 'oracle'){
        ensure_resource('package', ["oracle-${release}-${distribution}", "oracle-${release}-set-default"],
          {'ensure' => $version, 'require' => Package['java-common']}
        )

        if $set_oracle_default {
          ensure_resource('package', ["oracle-${release}-set-default"],
            {'ensure' => $version, 'require' => Package['java-common']}
          )
        }
      } else {
        package { 'java':
          ensure => $version,
          name   => $use_java_package_name,
        }
      }
    }

    default: {
      package { 'java':
        ensure => $version,
        name   => $use_java_package_name,
      }
    }
  }
  ->
  class { 'java::config': }
  -> anchor { 'java::end': }

}
