# private-chain

# Prerequisite
- aws-cli
- packer
- ansible
- jq
- direnv

# Environment valuables

```bash
# Create .envrc to suit your environment.
cp -pr .envrc.sample .envrc
direnv edit
```

# Packer
Build an AMI that the nodes of Parity PoA.  

## Parity resources
You have to change ETH account keys when you use this in production.
- `./packer/ansible/roles/parity/templates/PCParityPoA*_key.j2`

Also `spec.json`.
- `./packer/ansible/roles/parity/templates/spec.json.j2`

## Build
```bash
cd ./packer/
packer build ./parity-poa.json

# Add Generated AMI ID to .envrc
direnv edit
```

## Create EC2 KeyPair
```bash
aws ec2 create-key-pair --key-name private-chain
```

## Create EIP
```bash
# For Bastion server
aws ec2 allocate-address --domain vpc \
  | jq '.AllocationId' \
  | xargs aws ec2 create-tags --tags Key=Name,Value=EIPBastion-${ALIS_APP_ID} Key=Component,Value=PrivateChain --resources
  
# For NAT
aws ec2 allocate-address --domain vpc \
  | jq '.AllocationId' \
  | xargs aws ec2 create-tags --tags Key=Name,Value=EIPNAT Key=Component,Value=PrivateChain --resources
```

# Set SSM valuables
You have to specify SSM valuables as can as possible.
- See: https://github.com/AlisProject/environment


# CloudFormation

## Deployment

```bash;
./deploy.sh
```

### Fix API settings via a script

```bash
# Set PRIVATE_CHAIN_REST_API_ID to .envrc
direnv edit

./fix_api.sh
```

## After deployment

### Configure servers.
```bash
cd ansible
ansible-galaxy install -r requirements.yml
ansible-playbook -i hosts site.yml
```

### Connect Parity nodes each other
You can use `[parity dir]/enode.sh`.


### Migrate private chain contracts from Bastion server
See: [Private chain contracts](https://github.com/AlisProject/private-chain-contracts)

### Fix template.yaml's `FIXME:` tags and deploy again
Such as IAM Policies, and others.

### Set SSM valuables again
- See: https://github.com/AlisProject/environment

# Connect Instances via Bastion
- Prerequisite: [ec2ssh](https://github.com/mirakui/ec2ssh) 

```bash
cp -p .ec2ssh ~/
vi ~/.ec2ssh
```

Fix some place for your environment.  
Then execute `ec2ssh update`.

```bash
echo -e \\nHost PC*\\n  ProxyCommand ssh -W %h:%p Bastion >> ~/.ssh/config 
ec2ssh update
```

You can connect:

```bash
ssh PCParityPoA2a
```

Also you can use [tmuxinator](https://github.com/tmuxinator/tmuxinator).
```bash
cp -p ./private_chain.yml ~/.tmuxinator/
mux private_chain
```
