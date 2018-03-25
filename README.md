# private-net

# Prerequisite
- pyenv
- packer
- ansible

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
aws ec2 create-key-pair --key-name private-net
```

## Create EIP and edit template.yml
```bash
aws ec2 allocate-address --domain vpc
```
You have to change `PNEIPAssociation`'s `AllocationId` in `template.yml` to new AllocationId you got above.

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

### Associate EIP to Jump server that made by CloudFormation  

```bash
aws ec2 associate-address --allocation-id {eip-allocation-id} --instance {jump-server-instance-id}
```
