require "spec_helper"

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  describe "java_version" do
    context 'returns java version when java present' do
      context 'on OpenBSD' do
        before do
          Facter.fact(:operatingsystem).stubs(:value).returns("OpenBSD")
        end
        let(:facts) { {:operatingsystem => 'OpenBSD'} }
        it do
          java_version_output = <<-EOS
openjdk version "1.7.0_71"
OpenJDK Runtime Environment (build 1.7.0_71-b14)
OpenJDK 64-Bit Server VM (build 24.71-b01, mixed mode)
          EOS
          Facter::Util::Resolution.expects(:which).with("java").returns('/usr/local/jdk-1.7.0/jre/bin/java')
          Facter::Util::Resolution.expects(:exec).with("java -Xmx8m -version 2>&1").returns(java_version_output)
          Facter.value(:java_version).should == "1.7.0_71"
        end
      end
      context 'on other systems' do
        before do
          Facter.fact(:operatingsystem).stubs(:value).returns("MyOS")
        end
        let(:facts) { {:operatingsystem => 'MyOS'} }
        it do
          java_version_output = <<-EOS
java version "1.7.0_71"
Java(TM) SE Runtime Environment (build 1.7.0_71-b14)
Java HotSpot(TM) 64-Bit Server VM (build 24.71-b01, mixed mode)
          EOS
          Facter::Util::Resolution.expects(:exec).with("java -Xmx8m -version 2>&1").returns(java_version_output)
          Facter.value(:java_version).should == "1.7.0_71"
        end
      end
    end

    context 'returns nil when java not present' do
      context 'on OpenBSD' do
        before do
          Facter.fact(:operatingsystem).stubs(:value).returns("OpenBSD")
        end
        let(:facts) { {:operatingsystem => 'OpenBSD'} }
        it do
          Facter::Util::Resolution.stubs(:exec)
          Facter.value(:java_version).should be_nil
        end
      end
      context 'on other systems' do
        before do
          Facter.fact(:operatingsystem).stubs(:value).returns("MyOS")
        end
        let(:facts) { {:operatingsystem => 'MyOS'} }
        it do
          Facter::Util::Resolution.expects(:which).at_least(1).with("java").returns(false)
          Facter.value(:java_version).should be_nil
        end
      end
    end
  end
end
