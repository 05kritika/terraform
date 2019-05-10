control 'ec2-instance-1.1' do
  impact 1.0
  title 'Ensure no sensitive information is passed via the user-data'

  describe service('nginx') do
    it { should be_installed }
    it { should be_running }
    it { should be_enabled }

  end
end

describe port(80) do
  it { should be_listening }
end
