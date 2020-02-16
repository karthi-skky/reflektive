# Reflektive assignment 1
### Python script to get the services being used on AWS using boto3
As given in the assignment, getting the list of services being used in the given region
is not possible. As far as I know AWS makes different API calls to get the resources. So in one call
we can not get all the services which are being used. Alternative way is, we have to give the list of services names
as an input to boto3 and create client based on that and fetch the details.
This script will do the same. It takes the region name, services list as the input, and fetch their details.
It uses boto3 python aws client to perform actions on AWS.

### prerequisite ( aws cli (configured with access and secret keys ))
1. python3 -m pip install -r requirements.txt --user ( To install python packages )
2. python3 get_service_list.py 
