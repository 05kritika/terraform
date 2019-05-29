export AWS_REGION="us-west-2"

inspec exec test/verify/ -t aws:// --reporter cli html:www/AWS_Infra-test-Report.html

inspec exec test/verify/test.rb -t ssh://ubuntu@"$(cat public_dns.txt)" -i /home/ubuntu/kritika-key.pem --reporter cli html:www/ec2-nginx-test-Report.html
#telnet "$2" 80
