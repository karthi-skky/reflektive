from list_aws_services import AWS_Services

# initialize the aws_service function
aws_service = AWS_Services()
print(aws_service.region)

# Uncomment the next two lines to get running ec2 instances details
# ec2_details = aws_service.get_ec2_details()
# print(ec2_details)

# Uncomment the next two lines to get running rds instances details
# rds_details = aws_service.get_rds_details()
# print(rds_details)
