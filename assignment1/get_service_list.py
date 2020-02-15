from list_aws_services import AWS_Services

# initialize the aws_service function
aws_service = AWS_Services()
print(aws_service.region)
ec2_details = aws_service.get_ec2_details()
print(ec2_details)

rds_details = aws_service.get_rds_details()
print(rds_details)
