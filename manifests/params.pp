# Class: java_binary::params
#
# This class builds a hash of JDK/JRE packages and (for Debian)
# alternatives.  For wheezy/precise, we provide Oracle JDK/JRE
# options, even though those are not in the package repositories.
#
# For more info on how to package Oracle JDK/JRE, see the Debian wiki:
# http://wiki.debian.org/JavaPackage
#
# Because the alternatives system makes it very difficult to tell
# which Java alternative is enabled, we hard code the path to bin/java
# for the config class to test if it is enabled.
class java_binary::params {

  case $facts['os']['family'] {
    'RedHat': {
      case $facts['os']['name'] {
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific', 'OEL': {
          if (versioncmp($facts['os']['release']['full'], '5.0') < 0) {
            $jdk_package = 'java-1.6.0-sun-devel'
            $jre_package = 'java-1.6.0-sun'
          }
          elsif (versioncmp($facts['os']['release']['full'], '6.3') < 0) {
            $jdk_package = 'java-1.6.0-openjdk-devel'
            $jre_package = 'java-1.6.0-openjdk'
          }
          elsif (versioncmp($facts['os']['release']['full'], '7.1') < 0) {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
          }
          else {
            $jdk_package = 'java-1.8.0-openjdk-devel'
            $jre_package = 'java-1.8.0-openjdk'
          }
        }
        'Fedora': {
          if (versioncmp($facts['os']['release']['major'], '21') < 0) {
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
        default: { fail("unsupported os ${facts['os']['name']}") }
      }
      $java = {
        'jdk' => { 'package' => $jdk_package, },
        'jre' => { 'package' => $jre_package, },
      }
    }
    'Debian': {
      $dist = has_key($facts['os'], 'distro') ? {
        true =>  $facts['os']['distro']['codename'], # puppet 4.10.6 (puppetlabs)
        false =>  $facts['os']['lsb']['distcodename'] # puppet 4.8.2 (debian) WHY?!
      }

      case $dist {
        'lenny', 'squeeze', 'lucid', 'natty': {
          $java  = {
            'jdk' => {
              'package'          => 'openjdk-6-jdk',
              'alternative'      => "java-6-openjdk-${facts['os']['architecture']}",
              'alternative_path' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-openjdk/jre/',
            },
            'jre' => {
              'package'          => 'openjdk-6-jre-headless',
              'alternative'      => "java-6-openjdk-${facts['os']['architecture']}",
              'alternative_path' => '/usr/lib/jvm/java-6-openjdk/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-openjdk/jre/',
            },
            'sun-jre' => {
              'package'          => 'sun-java6-jre',
              'alternative'      => 'java-6-sun',
              'alternative_path' => '/usr/lib/jvm/java-6-sun/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-sun/jre/',
            },
            'sun-jdk' => {
              'package'          => 'sun-java6-jdk',
              'alternative'      => 'java-6-sun',
              'alternative_path' => '/usr/lib/jvm/java-6-sun/jre/bin/java',
              'java_home'        => '/usr/lib/jvm/java-6-sun/jre/',
            },
          }
        }
        'wheezy', 'precise','quantal','raring','saucy', 'trusty', 'utopic': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-7-jdk',
              'alternative'      => "java-1.7.0-openjdk-${facts['os']['architecture']}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${facts['os']['architecture']}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${facts['os']['architecture']}/",
            },
            'jre' => {
              'package'          => 'openjdk-7-jre-headless',
              'alternative'      => "java-1.7.0-openjdk-${facts['os']['architecture']}",
              'alternative_path' => "/usr/lib/jvm/java-1.7.0-openjdk-${facts['os']['architecture']}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.7.0-openjdk-${facts['os']['architecture']}/",
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
            'oracle-j2re' => {
              'package'          => 'oracle-j2re1.8',
              'alternative'      => 'j2re1.8-oracle',
              'alternative_path' => '/usr/lib/jvm/j2re1.8-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2re1.8-oracle/',
            },
            'oracle-j2sdk' => {
              'package'          => 'oracle-j2sdk1.8',
              'alternative'      => 'j2sdk1.8-oracle',
              'alternative_path' => '/usr/lib/jvm/j2sdk1.8-oracle/bin/java',
              'java_home'        => '/usr/lib/jvm/j2sdk1.8-oracle/',
              },
          }
        }
        'jessie', 'vivid', 'wily', 'xenial', 'stretch': {
          $java =  {
            'jdk' => {
              'package'          => 'openjdk-8-jdk',
              'alternative'      => "java-1.8.0-openjdk-${facts['os']['architecture']}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${facts['os']['architecture']}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${facts['os']['architecture']}/",
            },
            'jre' => {
              'package'          => 'openjdk-8-jre-headless',
              'alternative'      => "java-1.8.0-openjdk-${facts['os']['architecture']}",
              'alternative_path' => "/usr/lib/jvm/java-1.8.0-openjdk-${facts['os']['architecture']}/bin/java",
              'java_home'        => "/usr/lib/jvm/java-1.8.0-openjdk-${facts['os']['architecture']}/",
            }
          }
        }
        default: { fail("unsupported release ${facts['os']['distro']['codename']}") }
      }
    }
    'OpenBSD': {
      $java = {
        'jdk' => { 'package' => 'jdk', },
        'jre' => { 'package' => 'jre', },
      }
    }
    'FreeBSD': {
      $java = {
        'jdk' => { 'package' => 'openjdk', },
        'jre' => { 'package' => 'openjdk-jre', },
      }
    }
    'Solaris': {
      $java = {
        'jdk' => { 'package' => 'developer/java/jdk-7', },
        'jre' => { 'package' => 'runtime/java/jre-7', },
      }
    }
    'Suse': {
      case $facts['os']['name'] {
        'SLES': {
          case $facts['os']['release']['major']{
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
    default: { fail("unsupported platform ${facts['os']['family']}") }
  }
}