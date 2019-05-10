export AWS_REGION="us-west-2"

inspec exec test/verify/ -t aws://

inspec exec test/verify/test.rb -t ssh://ubuntu@"$1" -i /home/ubuntu/kritika-key.pem

telnet "$2" 80
