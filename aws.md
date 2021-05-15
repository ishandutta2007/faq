#### Web usage

okta

 * login page for okta authentication: https://okta.domain.com then it redirects to aws with predefined user access, e.g. https://eu-east-1.console.aws.amazon.com/console/home?region=eu-west-1#

sso

 * login page: https://domain.awsapps.com/start/

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

##### setup of SSO for aws 2.0 client

configure access:

    > aws configure sso
    SSO start URL [https://domain.awsapps.com/start/]:
    SSO Region [us-west-1]:
    There are 2 AWS accounts available to you.
    Using the account ID 123766484808
    The only role available to you is: UserAccess
    Using the role name "UserAccess"
    CLI default client Region [us-west-1]:
    CLI default output format [None]:

example of created config file

    > cat ~/.aws/config
    [default]
    # Ireland
    region = eu-west-1
    
    #[profile UserAccess-123766484808]
    [profile zona]
    sso_start_url = https://domain.awsapps.com/start/
    sso_region = us-west-1
    sso_account_id = 123766484808
    sso_role_name = UserAccess
    region = us-west-1

setup login script

    export PYTHONPATH=
    export LC_ALL=en_US.utf8
    
    proxyUser='johny'
    proxyPass='dee'
    proxyHost='proxy.domain.com'
    proxyPort='88'
    export http_proxy=http://${proxyUser}:${proxyPass}@${proxyHost}:${proxyPort}
    export https_proxy=${http_proxy}
    export HTTP_PROXY=http://${proxyUser}:${proxyPass}@${proxyHost}:${proxyPort}
    export HTTPS_PROXY=${HTTP_PROXY}
    
    if [[ -n "${1}" ]];then
     echo "using profile [${1}]"
    else
     echo "using profile [default]"
    fi
    
    aws sso login --profile $1
    export AWS_DEFAULT_PROFILE=$1

setup session script

    export accountNum=$(aws sts get-caller-identity | grep Account | sed 's/",$//;s/.*"//')
    export profile="$AWS_DEFAULT_PROFILE"
    export roleName='UserAccess'
    cmdOut="$(aws sts assume-role --role-arn arn:aws:iam::${accountNum}:role/${roleName} --role-session-name ${profile} --profile ${profile} | grep -E 'AccessKeyId|SecretAccessKey|SessionToken' | sed 's/^\s\+"//;s/": "/=/;s/",//')"
    
    echo "$cmdOut"
    
    export AWS_ACCESS_KEY_ID=$(echo "${cmdOut}" | grep 'AccessKeyId' | sed 's/AccessKeyId=//')
    export AWS_SECRET_ACCESS_KEY=$(echo "${cmdOut}" | grep 'SecretAccessKey' | sed 's/SecretAccessKey=//')
    export AWS_SESSION_TOKEN=$(echo "${cmdOut}" | grep 'SessionToken' | sed 's/SessionToken=//')


##### login via okta

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

automated script

    export PYTHONPATH=
    export LC_ALL=en_US.utf8
    
    proxyUser='johny'
    proxyPass='dee'
    proxyHost='proxy.domain.com'
    proxyPort='88'
    export http_proxy=http://${proxyUser}:${proxyPass}@${proxyHost}:${proxyPort}
    export https_proxy=${http_proxy}
    export HTTP_PROXY=http://${proxyUser}:${proxyPass}@${proxyHost}:${proxyPort}
    export HTTPS_PROXY=${HTTP_PROXY}

    if [[ -n "${1}" ]];then
     echo "using profile [${1}]"
     okta-awscli --okta-profile ${1} | tee okta.tmp.out
    else
     echo "using profile [default]"
     okta-awscli --okta-profile default | tee okta.tmp.out
    fi
    
    grep 'export ' okta.tmp.out | sed 's/.*export/export/g' > okta.tmp.export
    source okta.tmp.export
    rm okta.tmp.*
    
    export AWS_DEFAULT_PROFILE=$1
    aws iam list-account-aliases


##### looking around

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

update s3 policy

    aws s3api get-bucket-policy --bucket myBucket --query Policy --output text|jsonlint --format > policy.json
    vi policy.json
    aws s3api put-bucket-policy --bucket myBucket --policy file://policy.json

check on web

    curl http://myBucket.s3-eu-west-1.amazonaws.com/

delete a bucket

    aws s3 rb s3://myBucket
    aws s3api delete-bucket --bucket myBucket --region eu-west-1


##### working with ec2

access specific instance

    ssh -i ~/.ssh/aws-key.pem awsuser@aws.route54.address.com

list running instances

    myInstanceName='...'
    aws ec2 describe-instances --query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values='*${myInstanceName}*'"  --output table

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

list instance IP and tag value for defined filters and query

    aws ec2 describe-instances \
     --filter Name=tag-value,Values=userName \
     --query 'Reservations[].Instances[].[Tags[?starts_with(Key,`aws:cloudformation:stack-name`) == `true`].Value,InstanceId,InstanceType,PrivateIpAddress,State.Name,Monitoring.State,LaunchTime]' 

get names of all images of form specyfic user

    aws ec2 describe-images --owners "847074401234" \
     | jq -r '.Images[] | "\(.OwnerId)\t\(.Name)"'

list ec2 brief information

    aws ec2 describe-instances --instance-id ${myInstanceId} \
     --query 'Reservations[].Instances[].[Tags[?starts_with(Key,`ContactEmail`) == `true`],InstanceId,InstanceType,PrivateIpAddress,State.Name,Monitoring.State,LaunchTime]'

list ec2 instances from given autoscaling group

    aws autoscaling describe-auto-scaling-instances \
     --query 'AutoScalingInstances[?starts_with(AutoScalingGroupName,`'${groupName}'`) == `true`].InstanceId' \
     | jq -r '.[]'

list ec2 instances by owner tag

    aws ec2 describe-instances \
     --filter Name=tag-value,Values=${myOwner} \
     --query 'Reservations[].Instances[].[Tags[?starts_with(Key,`aws:cloudformation:stack-name`) == `true`].Value,InstanceId,InstanceType,PrivateIpAddress,State.Name,Monitoring.State,LaunchTime]'


##### working with cloud formation

validate script

    aws cloudformation validate-template --template-url https://s3.amazonaws.com/cloudformation-templates-us-east-1/WordPress.template
    aws cloudformation validate-template --template-body file://sampletemplate.json

advanced searching

    # JMESPath queries functions: starts_with, contains, ends_with, join, length, reverse, sort, sort_by
    aws cloudformation describe-stacks  --query 'Stacks[?starts_with(StackName, `test`) == `true`].StackName'

check stacks with issues

    aws cloudformation list-stacks --stack-status-filter CREATE_FAILED DELETE_FAILED UPDATE_ROLLBACK_FAILED ROLLBACK_COMPLETE  | egrep '"StackName"|"StackStatus"'

get stack resources

    aws cloudformation list-stack-resources --stack-name ${stackName}

get autoscaling group

    aws cloudformation list-stack-resources --stack-name ${stackName} \
     | jq -r '.StackResourceSummaries[]|select(.ResourceType == "AWS::AutoScaling::AutoScalingGroup")|.PhysicalResourceId'

list stacks by owner

    stackOwner='drunken.sailor'
    aws cloudformation describe-stacks \
     --query 'Stacks[?Parameters[?ParameterValue == `'${stackOwner}'`]].[StackName,StackStatus,CreationTime]'


##### working with autoscaling groups

get ec2s

    aws autoscaling describe-auto-scaling-groups  --auto-scaling-group-name ${autoscalingGroup} \
     | jq -r '.AutoScalingGroups[].Instances[].InstanceId'

##### working with roles and policies

lists all the managed policies that are available in your AWS account, including your own customer-defined managed policies and all AWS managed policies

    aws iam list-policies | jq '.Policies[].PolicyName' | sort

lists the IAM roles that have the specified path prefix. If there are none, the operation returns an empty list. 

    aws iam list-roles | jq -r '.Roles[] | "\(.RoleName)\t\(.Description)"'

lists the IAM users that have the specified path prefixi, if no path prefix is specified, the operation returns all users in the AWS account

    aws iam list-users | jq '.Users[].UserName'


##### working with monitoring

specyfic metric for all groups

    for autoscalingGroup in \
     myGroup
    do
     echo "aws cloudwatch get-metric-statistics \
      --namespace AWS/EC2 \
      --metric-name CPUUtilization \
      --dimensions Name=AutoScalingGroupName,Value=${autoscalingGroup} \
      --statistics 'Average' 'SampleCount' \
      --start-time  $(date --date='2 day ago' +'%FT%T%z') --end-time $(date --date='1 day ago' +'%FT%T%z') --period 300 \
      --query 'sort_by(Datapoints,&Average)[*]'
      #| jq -r '.Datapoints | sort_by(.Average)[]' "
    
     aws cloudwatch get-metric-statistics \
      --namespace AWS/EC2 \
      --metric-name CPUUtilization \
      --dimensions Name=AutoScalingGroupName,Value=${autoscalingGroup} \
      --statistics 'Average' 'SampleCount' \
      --start-time  $(date --date='2 day ago' +'%FT%T%z') --end-time $(date --date='1 day ago' +'%FT%T%z') --period 300 \
      --query 'sort_by(Datapoints,&Average)[*]'
      #| jq -r '.Datapoints | sort_by(.Average)[]'
    done

Filetring by timestamp:

    --query 'sort_by(Datapoints,&Timestamp)[*]'
    # | jq -r '.Datapoints | sort_by(.Timestamp)[]'


metric examples

    --metric-name CPUUtilization --dimensions Name=AutoScalingGroupName,Value=${autoscalingGroup} --statistics 'Average' 'SampleCount'
    --metric-name DiskWriteBytes --dimensions Name=AutoScalingGroupName,Value=${autoscalingGroup} --statistics 'Sum' 'SampleCount'

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
 - [ec2 user guide](https://github.com/awsdocs/amazon-ec2-user-guide)
 - [ec2 pricing guide](https://www.ec2instances.info/)
 - [ec2 pricing report](https://apps.cloudhealthtech.com/assets/aws/ec2/instances?table_form_submitted=true&tab=&account_type=&per_page=100&search=somename&selected_perspective=%3F+undefined%3Aundefined+%3F&selected_group=%3F+undefined%3Aundefined+%3F&selected_perspective_2=%3F+undefined%3Aundefined+%3F&aws_account_id=&aws_availability_zone_id=&is_active=Active&type=All&aws_instance_type=All&status=All&tenancy=All&is_spot=All&aws_auto_scaling_group_id=&has_tags=All&tag_key=All&launched_in=&start_before_time=&start_time=&stop_time=&stop_after_time=&pending_event=All&virtualization_type=All&hypervisor=All&report_id=#)

#### Windows

install toolset for power shell

     PS > Install-Module -Name AWSPowerShell


#### Links

 * filtering with `--query` [syntax](https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-output.html#controlling-output-filter)
 * documentation for [JMESPath](http://jmespath.org/specification.html)
