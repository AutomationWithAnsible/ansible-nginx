require 'serverspec'

# Required by serverspec
set :backend, :exec

describe 'Package Service' do
    describe package('nginx') do
      it { should be_installed }
    end

    describe service('nginx') do
      it { should be_enabled }
      it { should be_running }
    end

    describe port(1080) do
      it { should be_listening }
    end

end

describe 'NGinx sites-enabled' do

  describe file('/etc/nginx/sites-enabled/default') do
    it { should be_symlink }
    it { should be_linked_to '/etc/nginx/sites-available/default' }
  end

  describe file('/etc/nginx/sites-enabled/test.conf') do
    it { should be_symlink }
    it { should be_linked_to '/etc/nginx/sites-available/test.conf' }
  end

end

describe 'NGinx http content' do

 describe command "curl -s -L http://127.0.0.1:1080 | grep h1" do 
        its(:exit_status) { should eq 0 }
        its(:stdout) { should match "<h1>Welcome to nginx!</h1>" }
      end
end

