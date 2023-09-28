# Set your AWS credentials (replace with your own access key and secret key)
$AccessKey = "YOUR_ACCESS_KEY"
$SecretKey = "YOUR_SECRET_KEY"

# Set the AWS region
$Region = "us-east-1"

# Set EC2 instance parameters
$InstanceType = "t2.micro"
$ImageId = "ami-xxxxxxxxxxxxxxxxx"  # Replace with your desired AMI ID
$KeyName = "your-key-pair-name"      # Replace with your key pair name
$SecurityGroupId = "sg-xxxxxxxxxxxxxxxxx"  # Replace with your security group ID
$SubnetId = "subnet-xxxxxxxxxxxxxxxxx"    # Replace with your subnet ID
$InstanceName = "MyEC2Instance"            # Replace with your desired instance name

# Initialize AWS credentials
Set-AWSCredentials -AccessKey $AccessKey -SecretKey $SecretKey -StoreAs default

# Launch EC2 instance
$Instance = New-EC2Instance -ImageId $ImageId -InstanceType $InstanceType -KeyName $KeyName -SecurityGroup $SecurityGroupId -SubnetId $SubnetId -Region $Region

# Tag the instance with a name
Add-EC2ResourceTag -ResourceId $Instance.InstanceId -Tag @{Key="Name";Value=$InstanceName} -Region $Region

# Wait for the instance to be in the 'running' state
Write-Host "Waiting for the instance to be in the 'running' state..."
$Instance | Wait-EC2InstanceRunning -Region $Region
Write-Host "Instance is now running."

# Get the public DNS name of the instance
$PublicDns = Get-EC2Instance -InstanceId $Instance.InstanceId -Region $Region | Select-Object -ExpandProperty PublicDnsName

Write-Host "Public DNS: $PublicDns"

