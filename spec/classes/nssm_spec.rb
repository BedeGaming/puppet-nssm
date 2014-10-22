require 'spec_helper'

describe 'nssm' do
  context 'supported operating systems' do
    ['windows'].each do |osfamily|
      describe "nssm class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily     => osfamily,
          :architecture => 'amd64'
        }}

        it { should contain_class('nssm::params') }
        it { expect { should contain_class('nssm::install') } }

        it { expect { should contain_download_file('nssm-download').with_url('http://nssm.cc/release/nssm-2.23.zip') } }
        it { expect { should contain_exec('unzip-nssm').with_provider('powershell') } }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'nssm class without any parameters on Debian/Ubuntu' do
      let(:facts) {{
        :osfamily        => 'Debian',
        :operatingsystem => 'Ubuntu',
        :architecture    => 'amd64'
      }}

      it { expect { should contain_exec('unzip-nssm').to raise_error(Puppet::Error, /Debian not supported/) } }
    end
  end
end
