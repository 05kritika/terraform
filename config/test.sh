export AWS_REGION="us-west-2"

inspec exec test/verify/ -t aws://

inspec exec test/verify/test.rb -t ssh://ubuntu@"$(cat public_dns.txt)" -i /home/ubuntu/kritika-key.pem

#telnet "$2" 80
