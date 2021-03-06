require 'spec_helper'

describe 'java_binary', :type => :class do

  context 'select openjdk for Centos 5.8' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Centos',
          :architecture => 'amd64',
          :release => { :major => '5', :minor => '8', :full => '5.8' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1.6.0-openjdk-devel') }
  end

  context 'select openjdk for Centos 6.3' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Centos',
          :architecture => 'amd64',
          :release => { :major => '6', :minor => '3', :full => '6.3' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk-devel') }
  end

  context 'select openjdk for Centos 6.2' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Centos',
          :architecture => 'amd64',
          :release => { :major => '6', :minor => '2', :full => '6.2' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1.6.0-openjdk-devel') }
    it { is_expected.to_not contain_exec('update-java-alternatives') }
  end

  context 'select Oracle JRE with alternatives for Centos 6.3' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Centos',
          :architecture => 'amd64',
          :release => { :major => '6', :minor => '3', :full => '6.3' },
        },
      }
    end
    let(:params) { { 'package' => 'jre', 'java_alternative' => '/usr/bin/java', 'java_alternative_path' => '/usr/java/jre1.7.0_67/bin/java'} }
    it { is_expected.to contain_package('java').with_name('jre') }
    it { is_expected.to contain_exec('create-java-alternatives').with_command('alternatives --install /usr/bin/java java /usr/java/jre1.7.0_67/bin/java 20000') }
    it { is_expected.to contain_exec('update-java-alternatives').with_command('alternatives --set java /usr/java/jre1.7.0_67/bin/java') }
  end

  context 'select openjdk for Fedora 20' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Fedora',
          :architecture => 'amd64',
          :release => { :major => '20', :minor => '0', :full => '20.0' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk-devel') }
  end

  context 'select openjdk for Fedora 21' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Fedora',
          :architecture => 'amd64',
          :release => { :major => '21', :minor => '0', :full => '21.0' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1.8.0-openjdk-devel') }
  end

  context 'select passed value for Fedora 20' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Fedora',
          :architecture => 'amd64',
          :release => { :major => '20', :minor => '0', :full => '20.0' },
        },
      }
    end
    let(:params) { { 'distribution' => 'jre' } }
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk') }
  end

  context 'select passed value for Fedora 21' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Fedora',
          :architecture => 'amd64',
          :release => { :major => '21', :minor => '0', :full => '21.0' },
        },
      }
    end
    let(:params) { { 'distribution' => 'jre' } }
    it { is_expected.to contain_package('java').with_name('java-1.8.0-openjdk') }
  end

  context 'select passed value for Centos 5.3' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Centos',
          :architecture => 'amd64',
          :release => { :major => '5', :minor => '3', :full => '5.3' },
        },
      }
    end
    let(:params) { { 'package' => 'jdk' } }
    it { is_expected.to contain_package('java').with_name('jdk') }
    it { is_expected.to_not contain_exec('update-java-alternatives') }
  end

  context 'select default for Centos 5.3' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Centos',
          :architecture => 'amd64',
          :release => { :major => '5', :minor => '3', :full => '5.3' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1.6.0-openjdk-devel') }
    it { is_expected.to_not contain_exec('update-java-alternatives') }
  end

  context 'Debian Squeeze' do
    let(:facts) do
      {
        # still old fact is needed due to this
        # https://github.com/puppetlabs/puppetlabs-apt/blob/master/manifests/params.pp#L3
        :osfamily => 'Debian',
        :os => {
          :family => 'Debian',
          :name => 'Debian',
          :architecture => 'amd64',
          :distro => { :codename => 'squeeze' },
          :release => { :major => '6', :minor => '0', :full => '6.0.5' },
        },
        :puppetversion => Puppet.version,
      }
    end

    context 'select default for Debian Squeeze' do
      it { is_expected.to contain_package('java').with_name('openjdk-6-jdk') }
      it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-6-openjdk-amd64 --jre') }
    end

    context 'select Oracle JRE for Debian Squeeze' do
      let(:params) { { 'distribution' => 'sun-jre', } }
      it { is_expected.to contain_package('java').with_name('sun-java6-jre') }
      it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-6-sun --jre') }
    end

    context 'select OpenJDK JRE for Debian Squeeze' do
      let(:params) { { 'distribution' => 'jre', } }
      it { is_expected.to contain_package('java').with_name('openjdk-6-jre-headless') }
      it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-6-openjdk-amd64 --jre-headless') }
    end
  end

  context 'Ubuntu Vivid (15.04)' do
    let(:facts) do
      {
        # still old fact is needed due to this
        # https://github.com/puppetlabs/puppetlabs-apt/blob/master/manifests/params.pp#L3
        :osfamily => 'Debian',
        :os => {
          :family => 'Debian',
          :name => 'Ubuntu',
          :architecture => 'amd64',
          :distro => { :codename => 'vivid' },
          :release => { :major => '15', :minor => '04', :full => '15.04' },
        },
        :puppetversion => Puppet.version,
      }
    end

    context 'select jdk for Ubuntu Vivid (15.04)' do
      let(:params) { { 'distribution' => 'jdk' } }
      it { is_expected.to contain_package('java').with_name('openjdk-8-jdk') }
    end

    context 'select jre for Ubuntu Vivid (15.04)' do
      let(:params) { { 'distribution' => 'jre' } }
      it { is_expected.to contain_package('java').with_name('openjdk-8-jre-headless') }
    end
  end

  context 'select openjdk for Amazon Linux' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Amazon',
          :architecture => 'amd64',
          :release => { :major => '3', :minor => '4', :full => '3.4.43-43.43.amzn1.x86_64' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk-devel') }
  end

  context 'select passed value for Amazon Linux' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Amazon',
          :architecture => 'amd64',
          :release => { :major => '5', :minor => '3', :full => '5.3.43-43.43.amzn1.x86_64' },
        },
      }
    end
    let(:params) { { 'distribution' => 'jre' } }
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk') }
  end

  context 'select openjdk for Oracle Linux' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'OracleLinux',
          :architecture => 'amd64',
          :release => { :major => '6', :minor => '4', :full => '6.4' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk-devel') }
  end

  context 'select openjdk for Oracle Linux 6.2' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'OracleLinux',
          :architecture => 'amd64',
          :release => { :major => '6', :minor => '2', :full => '6.2' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1.6.0-openjdk-devel') }
  end

  context 'select passed value for Oracle Linux' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'OracleLinux',
          :architecture => 'amd64',
          :release => { :major => '6', :minor => '3', :full => '6.3' },
        },
      }
    end
    let(:params) { { 'distribution' => 'jre' } }
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk') }
  end

  context 'select passed value for Scientific Linux' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :os => {
          :family => 'RedHat',
          :name => 'Scientific',
          :architecture => 'amd64',
          :release => { :major => '6', :minor => '4', :full => '6.4' },
        },
      }
    end
    let(:params) { { 'distribution' => 'jre' } }
    it { is_expected.to contain_package('java').with_name('java-1.7.0-openjdk') }
  end

  context 'select default for OpenSUSE 12.3' do
    let(:facts) do
      {
        :osfamily => 'Suse',
        :os => {
          :family => 'Suse',
          :name => 'OpenSUSE',
          :architecture => 'amd64',
          :release => { :major => '12', :minor => '3', :full => '12.3' },
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('java-1_7_0-openjdk-devel')}
  end

  context 'select jdk for OpenBSD' do
    let(:facts) do
      {
        :osfamily => 'OpenBSD',
        :os => {
          :family => 'OpenBSD',
          :name => 'OpenBSD',
          :architecture => 'amd64',
        },
      }
    end
    it { is_expected.to contain_package('java').with_name('jdk') }
  end

  context 'select jre for OpenBSD' do
    let(:facts) do
      {
        :osfamily => 'OpenBSD',
        :os => {
          :family => 'OpenBSD',
          :name => 'OpenBSD',
          :architecture => 'amd64',
        },
      }
    end
    let(:params) { { 'distribution' => 'jre' } }
    it { is_expected.to contain_package('java').with_name('jre') }
  end

  describe 'incompatible OSs' do
    [
      {
        # C14706
        :osfamily => 'windows',
        :os => {
          :family => 'windows',
          :name => 'windows',
        },
        :release => { :major => '8', :minor => '1', :full => '8.1' },
      },
      {
        # C14707
        :osfamily => 'Darwin',
        :os => {
          :family => 'Darwin',
          :name => 'Darwin',
        },
        :release => { :major => '13', :minor => '3', :full => '13.3.0' },
      },
      {
        # C14708
        :osfamily => 'AIX',
        :os => {
            :family => 'AIX',
            :name => 'AIX',
        },
        :release => {:full => '7100-02-00-000' },
      },
      {
        # C14708
        :operatingsystemrelease => '6100-07-04-1216',
        :osfamily => 'AIX',
        :os => {
          :family => 'AIX',
          :name => 'AIX',
        },
        :release => {:full => '6100-07-04-1216' },
      },
      {
        # C14708
        :operatingsystemrelease => '6100-07-04-1216',
        :osfamily => 'AIX',
        :os => {
          :family => 'AIX',
          :name => 'AIX',
        },
        :release => {:full => '5300-12-01-1016' },
      },
    ].each do |facts|
      let(:facts) { facts }
      it "is_expected.to fail on #{facts[:os][:family]} #{facts[:release][:full]}" do
        expect { catalogue }.to raise_error Puppet::Error, /unsupported platform/
      end
    end
  end


  context 'Debian Wheezy' do
    let(:facts) do
      {
        # still old fact is needed due to this
        # https://github.com/puppetlabs/puppetlabs-apt/blob/master/manifests/params.pp#L3
        :osfamily => 'Debian',
        :os => {
          :family => 'Debian',
          :name => 'Debian',
          :architecture => 'amd64',
          :distro => { :codename => 'wheezy' },
          :release => { :major => '7', :minor => '1', :full => '7.1' },
        },
        :puppetversion => Puppet.version,
      }
    end

    context 'select default for Debian Wheezy' do
      it { is_expected.to contain_package('java').with_name('openjdk-7-jdk') }
      it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-1.7.0-openjdk-amd64 --jre') }
    end

    context 'select Oracle JRE for Debian Wheezy' do
      let(:params) { { 'distribution' => 'oracle-jre' } }
      it { is_expected.to contain_package('java').with_name('oracle-j2re1.7') }
      it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set j2re1.7-oracle --jre') }
    end

    context 'select random alternative for Debian Wheezy' do
      let(:params) { { 'java_alternative' => 'bananafish' } }
      it { is_expected.to contain_package('java').with_name('openjdk-7-jdk') }
      it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set bananafish --jre') }
    end

    context 'select OpenJDK JRE for Debian Wheezy' do
      let(:params) { { 'distribution' => 'jre' } }
      it { is_expected.to contain_package('java').with_name('openjdk-7-jre-headless') }
      it { is_expected.to contain_exec('update-java-alternatives').with_command('update-java-alternatives --set java-1.7.0-openjdk-amd64 --jre-headless') }
    end

    context 'select Oracle JRE for Debian Wheezy' do
      let(:params) do
        {
        'repository'            => 'webupd8team',
        'distribution'          => 'oracle',
        'release'               => 'java7',
        'accept_oracle_license' => true,
      }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('apt') }
      it { is_expected.to contain_apt__source('webupd8team-java').with_location('http://ppa.launchpad.net/webupd8team/java/ubuntu') }
      context 'java 7' do
        it { is_expected.to contain_package('java').with_name('oracle-java7-installer') }
      end

      context 'without accepting license' do
        let(:params) do
          {
          'repository'            => 'webupd8team',
          'distribution'          => 'oracle',
          'accept_oracle_license' => false,
        }
        end
        it {
          expect { is_expected.to raise_error(Puppet::Error) }
        }
      end

      context 'java 7 as default' do
        let(:params) do
          {
          'repository'            => 'webupd8team',
          'distribution'          => 'oracle',
          'release'               => 'java7',
          'accept_oracle_license' => true,
        }
        end
        it { is_expected.to contain_package('java').with_name('oracle-java7-installer') }
      end

      context 'java 8' do
        let(:params) do
          {
          'repository'            => 'webupd8team',
          'distribution'          => 'oracle',
          'release'               => 'java8',
          'accept_oracle_license' => true,
        }
        end
        it { is_expected.to contain_package('java').with_name('oracle-java8-installer') }
      end
    end
  end

  context 'select Oracle JDK for Debian Jessie' do
    let(:facts) do
      {
        # still old fact is needed due to this
        # https://github.com/puppetlabs/puppetlabs-apt/blob/master/manifests/params.pp#L3
        :osfamily => 'Debian',
        :os => {
          :family => 'Debian',
          :name => 'Debian',
          :architecture => 'amd64',
          :distro => { :codename => 'jessie' },
          :release => { :major => '8', :minor => '1', :full => '8.1' },
        },
        :puppetversion => Puppet.version,
      }
    end


    let(:params) do
      {
      'distribution'          => 'oracle',
      'repository'            => 'webupd8team',
      'release'               => 'java9',
      'accept_oracle_license' => true,
    }
    end
    it { is_expected.to contain_class('java_binary::repo') }
    it { is_expected.to contain_class('apt') }
    it { is_expected.to contain_package('java').with_name('oracle-java9-installer') }
    it { is_expected.to contain_apt__source('webupd8team-java').with_location('http://ppa.launchpad.net/webupd8team/java/ubuntu') }
  end

  context 'Debian Stretch' do
    let(:facts) do
      {
        # still old fact is needed due to this
        # https://github.com/puppetlabs/puppetlabs-apt/blob/master/manifests/params.pp#L3
        :osfamily => 'Debian',
        :os => {
          :family => 'Debian',
          :name => 'Debian',
          :architecture => 'amd64',
          :distro => { :codename => 'stretch' },
          :release => { :major => '9', :minor => '1', :full => '9.1' },
        },
        :puppetversion => Puppet.version,
      }
    end

    let(:params) do
      {
      'release'               => 'java8',
    }
    end
    it { is_expected.to contain_class('java_binary::repo') }
    it { is_expected.to contain_class('apt') }
    it { is_expected.to contain_package('java').with_name('openjdk-8-jdk') }
  end
end
