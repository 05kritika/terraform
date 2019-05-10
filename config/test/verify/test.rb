control 'ec2-instance-1.1' do
  impact 1.0
  title 'Test case to check if the package is successfully installed and configured'

  describe service('nginx') do
    it { should be_installed }
    it { should be_running }
    it { should be_enabled }

  end
end

describe port(80) do
  it { should be_listening }
end
