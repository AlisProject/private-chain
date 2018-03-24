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

## Deploy
```bash;
aws cloudformation deploy \
  --template-file packaged-template.yaml \
  --stack-name YOURSTACKNAMEHERE \
  --capabilities CAPABILITY_IAM
```
