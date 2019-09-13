#### Web

login page for okta authentication: okta.domain.com then it redirects to aws with predefined user access, e.g. https://eu-west-1.console.aws.amazon.com/console/home?region=eu-west-1#

#### Linux

##### setup client for python3

install okta client

    python3 -m pip install --upgrade awscli okta-awscli
    #pip3 install awscli okta-awscli --proxy="https://user:pass@proxy.com:80"

create config file: ~/.okta-aws

    echo '
    [default]
    base-url = company.okta.com
    ' > ~/.okta-aws

configure AWS client ~/.aws/config

    mkdir -p ~/.aws
    echo '
    [default]
    # Ireland
    #region = eu-west-1
    # Oregon
    region = us-west-2
    ' > ~/.aws/config

update env if proxy needed or multiple python env exists

    export PYTHONPATH=
    export LC_ALL=en_US.utf8
    export http_proxy="http://user:pass@host.domain.com:80"
    export https_proxy="$http_proxy" ftp_proxy="$http_proxy"

##### login & looking around

login with okta, your user and password and code from Google Authenticator

    okta-awscli
     Enter username: ...
     Enter password: ...
     Registered MFA factors:
     1: Google Authenticator
     2: Okta Verify - Push
     3: Okta Verify
     Please select the MFA factor: 1
     Enter MFA token: XXXXXX
     1: arn:aws:iam::XXXXXXXXXXXX:role/UserAccess
     Please select the AWS role: 1
     export AWS_ACCESS_KEY_ID=XXX...
     export AWS_SECRET_ACCESS_KEY=XXX...
     export AWS_SESSION_TOKEN=XXX...

copy&paste printed exports to your shell

validate access with simple commands

    # return details  about  the IAM identity whose credentials are used to call the API.
    aws sts get-caller-identity
    # list the account alias associated with the AWS account
    aws iam list-account-aliases
    aws iam get-user
    aws s3 ls

simple check example with bare python and boto module

    python3 -c 'import boto3;print(boto3.Session().region_name)'

##### working with s3

create a bucket

    aws s3 mb s3://myBucket
    aws s3api create-bucket --bucket myBucket --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1


list all buckets owned by the authenticated sender of the request

    aws s3api list-buckets
    aws s3 ls

list buckets content by the authenticated sender of the request

    aws s3 ls myBucket
    aws s3 ls s3://myBucket 

copy files and directories

    aws s3 cp hello.aws.txt s3://myBucket
    aws s3 cp myDir s3://myBucket/ --recursive
    aws s3 cp s3://yourBucket/yourDir s3://myBucket/myExistingDir --recursive
    aws s3 cp s3://yourBucket/yourDir s3://myBucket/myNotExistingDir --recursive


remove files and directories

    aws s3 rm s3://myBucket/myDir/ --recursive

check on web

    curl http://myBucket.s3-eu-west-1.amazonaws.com/

update s3 acl

    aws s3api put-bucket-acl --acl public-read --bucket myBucket
    aws s3api get-bucket-acl --bucket myBucket

check on web

    curl http://myBucket.s3-eu-west-1.amazonaws.com/

delete a bucket

    aws s3 rb s3://myBucket
    aws s3api delete-bucket --bucket myBucket --region eu-west-1


##### working with ec2

get instance status

    myInstanceId='....'
    aws ec2 describe-instances --instance-ids ${instanceId} \
     | jq -r '.Reservations[0].Instances[0].State.Name'

get instance IP

    aws ec2 describe-instances --instance-ids ${instanceId} \
     | jq -r '.Reservations[0].Instances[0].PrivateIpAddress'

get logs from instance

    echo -e "$(aws ec2 get-console-output --instance-id ${myInstanceId})"

run command on instance

    myCmd='cat /var/log/cfn-init.log'
    myAwsCmdId=$(aws ssm send-command \
                  --instance-ids ${myInstanceId} \
                  --document-name "AWS-RunShellScript" \
                  --parameters commands="${myCmd}" \
                  --output text \
                  --query "Command.CommandId" \
                 )
    echo ${myAwsCmdId}
    aws ssm list-command-invocations \
     --command-id "${myAwsCmdId}" \
     --details \
     --query "CommandInvocations[].CommandPlugins[].{Output:Output}" 

##### working with cloud formation

validate script

    aws cloudformation validate-template --template-url https://s3.amazonaws.com/cloudformation-templates-us-east-1/WordPress.template
    aws cloudformation validate-template --template-body file://sampletemplate.json

advanced searching

    # JMESPath queries functions: starts_with, contains, ends_with, join, length, reverse, sort, sort_by
    aws cloudformation describe-stacks  --query 'Stacks[?starts_with(StackName, `test`) == `true`].StackName'

check stacks with issues

    aws cloudformation list-stacks --stack-status-filter CREATE_FAILED DELETE_FAILED UPDATE_ROLLBACK_FAILED ROLLBACK_COMPLETE  | egrep '"StackName"|"StackStatus"'

##### working with costs

get billing estimation 

    aws cloudwatch get-metric-statistics \
     --namespace "AWS/Billing" \
     --metric-name "EstimatedCharges" \
     --dimension "Name=Currency,Value=USD" \
     --start-time $(date +"%Y-%m-%dT%H:%M:00" --date="-12 hours") \
     --end-time $(date +"%Y-%m-%dT%H:%M:00") \
     --statistic Maximum \
     --period 60 \
     #--output text

##### links

Documentation
 * [ec2 user guide](https://github.com/awsdocs/amazon-ec2-user-guide)

#### Windows

install toolset for power shell

     PS > Install-Module -Name AWSPowerShell


#### Links

 * filtering with `--query` [syntax](https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-output.html#controlling-output-filter)
 * documentation for [JMESPath](http://jmespath.org/specification.html)
