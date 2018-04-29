# private-chain

# Prerequisite
- pyenv
- packer
- ansible
- jq
- direnv

# Environment valuables

```bash
# Create .envrc to suit your environment.
cp -pr .envrc.sample .envrc
vi .envrc # edit

# allow
direnv allow
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

# CloudFormation


## Create EC2 KeyPair
```bash
aws ec2 create-key-pair --key-name private-chain
```

## Create EIP
```bash
# For Bastion server
aws ec2 allocate-address --domain vpc \
  | jq '.AllocationId' \
  | xargs aws ec2 create-tags --tags Key=Name,Value=EIPBastion Key=Component,Value=PrivateChain --resources
  
# For NAT
aws ec2 allocate-address --domain vpc \
  | jq '.AllocationId' \
  | xargs aws ec2 create-tags --tags Key=Name,Value=EIPNAT Key=Component,Value=PrivateChain --resources  
  
# Add Generated Allocation IDs to .envrc
direnv edit  
```

## Deploy
You have to specify all of your environment valuables to `.envrc`.

```bash;
aws cloudformation deploy \
  --template-file template.yaml \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    ParityNodesAMI=${PARITY_NODES_AMI} \
    BastionAllocationId=${BASTION_ALLOCATION_ID} \
    NatAllocationId=${NAT_ALLOCATION_ID} \
    AccountsNewRequestTemplate=${ACCOUNTS_NEW_REQUEST_TEMPLATE} \
    WalletBalanceRequestTemplate=${WALLET_BALANCE_REQUEST_TEMPLATE} \
  --stack-name ${CLOUDFORMATION_STACK_NAME}privatechain
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
