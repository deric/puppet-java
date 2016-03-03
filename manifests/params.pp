# Class: java::params
#
# This class builds a hash of JDK/JRE packages and (for Debian)
# alternatives.  For wheezy/precise, we provide Oracle JDK/JRE
# options, even though those are not in the package repositories.
#
class java::params {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific', 'OEL': {
          if (versioncmp($::operatingsystemrelease, '5.0') < 0) {
            $jdk_package = 'java-1.6.0-sun-devel'
            $jre_package = 'java-1.6.0-sun'
          }
          elsif (versioncmp($::operatingsystemrelease, '6.3') < 0) {
            $jdk_package = 'java-1.6.0-openjdk-devel'
            $jre_package = 'java-1.6.0-openjdk'
          }
          else {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
          }
        }
        'Fedora': {
          if (versioncmp($::operatingsystemrelease, '21') < 0) {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
          }
          else {
            $jdk_package = 'java-1.8.0-openjdk-devel'
            $jre_package = 'java-1.8.0-openjdk'
          }
        }
        'Amazon': {
          $jdk_package = 'java-1.7.0-openjdk-devel'
          $jre_package = 'java-1.7.0-openjdk'
        }
        default: { fail("unsupported os ${::operatingsystem}") }
      }
      $java = {
        'jdk' => { 'package' => $jdk_package, },
        'jre' => { 'package' => $jre_package, },
      }
    }
    'Debian': {
      case $::lsbdistcodename {
        'wheezy', 'jessie', 'precise','quantal','raring','saucy', 'trusty', 'utopic': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-7-jdk',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'jre' => {
              'package'          => 'openjdk-7-jre-headless',
              'alternative'      => "java-1.7.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${::architecture}/",
            },
            'oracle-jre' => {
              'package'          => 'oracle-j2re1.7',
              'alternative'      => 'j2re1.7-oracle',
              'alternative_path' => '/usr/lib/jvm/j2re1.7-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2re1.7-oracle/',
            },
            'oracle-jdk' => {
              'package'          => 'oracle-j2sdk1.7',
              'alternative'      => 'j2sdk1.7-oracle',
              'alternative_path' => '/usr/lib/jvm/j2sdk1.7-oracle/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/j2sdk1.7-oracle/jre/',
            },
            'oracle' => {
              'package'          => 'oracle-jdk7-installer',
              'alternative'      => 'java-7-oracle',
              'alternative_path' => '/usr/lib/jvm/java-7-oracle/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-7-oracle/',
            },
          }
        }
        'vivid': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-8-jdk',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
            },
            'jre' => {
              'package'          => 'openjdk-8-jre-headless',
              'alternative'      => "java-1.8.0-openjdk-${::architecture}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${::architecture}/",
            }
          }
        }
        default: { fail("unsupported release ${::lsbdistcodename}") }
      }
    }
    'OpenBSD': {
      $java = {
        'jdk' => { 'package' => 'jdk', },
        'jre' => { 'package' => 'jre', },
      }
    }
    'Solaris': {
      $java = {
        'jdk' => { 'package' => 'developer/java/jdk-7', },
        'jre' => { 'package' => 'runtime/java/jre-7', },
      }
    }
    'Suse': {
      case $::operatingsystem {
        'SLES': {
          case $::operatingsystemmajrelease{
            default: {
              $jdk_package = 'java-1_6_0-ibm-devel'
              $jre_package = 'java-1_6_0-ibm'
            }
            '12': {
              $jdk_package = 'java-1_7_0-openjdk-devel'
              $jre_package = 'java-1_7_0-openjdk'
            }
          }
        }
        'OpenSuSE': {
          $jdk_package = 'java-1_7_0-openjdk-devel'
          $jre_package = 'java-1_7_0-openjdk'
        }
        default: {
          $jdk_package = 'java-1_6_0-ibm-devel'
          $jre_package = 'java-1_6_0-ibm'
        }
      }
      $java = {
        'jdk' => { 'package' => $jdk_package, },
        'jre' => { 'package' => $jre_package, },
      }
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }
}
