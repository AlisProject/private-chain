# private-chain

# Prerequisite
- pyenv
- packer
- ansible
- jq

# Environment valuables
```bash
export AWS_ACCESS_KEY_ID=YOURAWSACCESSKEY
export AWS_SECRET_ACCESS_KEY=YOURAWSSECRETKEY
``` 

# Packer
Build an AMI that the nodes of Parity PoA.  

## Build
```bash
cd ./packer/
packer build ./parity-poa.json
```

## Validation
```bash
packer validate ./parity-poa.json
```

# CloudFormation


## Create EC2 KeyPair
```bash
aws ec2 create-key-pair --key-name private-chain
```

## Create EIP and edit template.yml
```bash
# For Bastion server
aws ec2 allocate-address --domain vpc \
  | jq '.AllocationId' \
  | xargs aws ec2 create-tags --tags Key=Name,Value=EIPBastion Key=Component,Value=PrivateChain --resources
  
# For NAT
aws ec2 allocate-address --domain vpc \
  | jq '.AllocationId' \
  | xargs aws ec2 create-tags --tags Key=Name,Value=EIPNAT Key=Component,Value=PrivateChain --resources  
```
You have to change `AllocationId` in EIP section of `template.yml` to new AllocationIds you got above.

## Deploy
```bash;
aws cloudformation deploy \
  --template-file packaged-template.yaml \
  --stack-name YOURSTACKNAMEHERE \
  --capabilities CAPABILITY_IAM
```

## EIP

### Create EIP
```bash
aws ec2 allocate-address --domain vpc
```

### Associate EIP to Bastion server that made by CloudFormation  

```bash
aws ec2 associate-address --allocation-id {eip-allocation-id} --instance {bastion-server-instance-id}
```
