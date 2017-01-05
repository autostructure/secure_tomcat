require 'spec_helper'

describe 'secure_tomcat' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "secure_tomcat class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('secure_tomcat::params') }
          it { is_expected.to contain_class('secure_tomcat::install').that_comes_before('secure_tomcat::config') }
          it { is_expected.to contain_class('secure_tomcat::config') }
          it { is_expected.to contain_class('secure_tomcat::service').that_subscribes_to('secure_tomcat::config') }

          it { is_expected.to contain_service('secure_tomcat') }
          it { is_expected.to contain_package('secure_tomcat').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'secure_tomcat class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          osfamily: 'Solaris',
          operatingsystem: 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('secure_tomcat') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
