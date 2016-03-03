# puppet-java

Puppet module for managing binary packages of Java with support of Java 8/9 on Debian based distribution.

Usage:
```puppet
class{'java':
  repository            => 'webupd8team',
  distribution          => 'oracle',
  set_oracle_default    => true,
  release               => 'java8',
  accept_oracle_license => true,
}
```
