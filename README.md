# private-net

# Prerequisite
- pyenv
- packer

# Environment valuables
```bash
export AWS_ACCESS_KEY_ID=YOURAWSACCESSKEY
export AWS_SECRET_ACCESS_KEY=YOURAWSSECRETKEY
``` 

# Packer

## Build
```bash
packer build ./packer/parity-pos.json
```

# CloudFormation
```bash
aws cloudformation deploy \
  --template-file packaged-template.yaml \
  --stack-name YOURSTACKNAMEHERE \
  --capabilities CAPABILITY_IAM
```
