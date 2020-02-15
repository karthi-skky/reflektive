import boto3
from prettytable import PrettyTable

class AWS_Services():
    """docstring for AWS_Services."""

    def __init__(self):
        super(AWS_Services, self).__init__()
        # initialize boto3 function to perform operations on AWS services
        self.session = boto3.Session()

        # list the regions to fetch resources being used
        regions = self.session.get_available_regions("ec2")
        for region in regions:
            print(region)

        while True:
            region_name = input("Select one region from the above list: ")
            if not region_name in regions:
                print("Please choose the region from the list")
                continue
            else:
                break
        self.region = region_name

    def get_ec2_details(self):
        ec2_instance_list = []
        ec2_client = boto3.client("ec2", region_name = self.region)
        ec2_instances = ec2_client.describe_instances()
        if ec2_instances['ResponseMetadata']['HTTPStatusCode'] == 200:
            for reservation in ec2_instances['Reservations']:
                for instance in reservation['Instances']:
                    ec2_instance_dict = {
                    "instanceID": instance["InstanceId"],
                    "instanceType": instance["InstanceType"],
                    "status": instance["State"]["Name"],
                    "AZ": instance["Placement"]["AvailabilityZone"]
                    }
                    ec2_instance_list.append(ec2_instance_dict)

            if ec2_instance_list:
                ec2_pretty=PrettyTable()
                ec2_pretty.title = 'EC2 Details'
                ec2_pretty.field_names = ec2_instance_list[0].keys()
                for ec2 in ec2_instance_list:
                    ec2_pretty.add_row(ec2.values())
                return ec2_pretty
            else:
                return "no instances are running in {}".format(self.region)
        else:
            return "error in fetching instance details"

    def get_rds_details(self):
        rds_list = []
        rds_client = boto3.client('rds', region_name = self.region)
        rds_instances = rds_client.describe_db_instances()
        if rds_instances['ResponseMetadata']['HTTPStatusCode'] == 200:
            for rds_instance in rds_instances["DBInstances"]:
                rds_instance_dict = {
                "DBInstanceName": rds_instance["DBInstanceIdentifier"],
                "DBInstanceClass": rds_instance["DBInstanceClass"],
                "DBEngine": rds_instance["Engine"],
                "DBInstanceStatus": rds_instance["DBInstanceStatus"],
                "DBAddress": rds_instance["Endpoint"]["Address"],
                "DBPort": rds_instance["Endpoint"]["Port"]
                }
                rds_list.append(rds_instance_dict)
            if rds_list:
                rds_pretty=PrettyTable()
                rds_pretty.title = 'RDS Details'
                rds_pretty.field_names = rds_list[0].keys()
                for rds in rds_list:
                    rds_pretty.add_row(rds.values())
                return rds_pretty
            else:
                return "no rds instaces available in {}".format(self.region)
        else:
            return "error in fetching db details"
