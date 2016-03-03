# Repositories with binary Java packages
class java::repo(
  $repository,
  ) {

  case $::osfamily {
    Debian: {
      case $repository {
        'webupd8team' :{
         case $::operatingsystem {
            Debian: {
              $dist_name = 'trusty'
            }

            Ubuntu: {
              $dist_name = $::lsbdistcodename
            }

            default: {
              notice "Unsupported operatingsystem ${::operatingsystem}"
            }
          }

          include apt
          apt::source { 'webupd8team-java':
            location    => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
            release     => $dist_name,
            repos       => 'main',
            key         => '7B2C3B0889BF5709A105D03AC2518248EEA14886',
            key_server  => 'keyserver.ubuntu.com',
            include_src => true,
          }
          ->
          Class['apt::update']

          file { '/tmp/java.preseed':
            content => template('java/preseed.erb'),
            mode   => '0600',
            backup => false,
            before => Anchor['java::repo:']
          }
        }
        default: {}
      }
    }
  }
}