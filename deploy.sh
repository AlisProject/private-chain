#!/usr/bin/env bash
aws cloudformation deploy \
  --template-file template.yaml \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    ParityNodesAMI=${PARITY_NODES_AMI} \
    BastionAllocationId=${BASTION_ALLOCATION_ID} \
    NatAllocationId=${NAT_ALLOCATION_ID} \
    EC2DeleteOnTermination=${EC2_DELETE_ON_TERMINATION} \
    AccountsNewRequestPassword=${ACCOUNTS_NEW_REQUEST_PASSWORD} \
    ParityNodesInstanceType=${PARITY_NODES_INSTANCE_TYPE} \
    ParityNodesVolumeSize=${PARITY_NODES_VOLUME_SIZE} \
    PrivateChainMainSigner=${PRIVATE_CHAIN_MAIN_SIGNER} \
    PrivateChainAlisTokenAddress=${PRIVATE_CHAIN_ALIS_TOKEN_ADDRESS} \
  --stack-name ${CLOUDFORMATION_STACK_NAME}privatechain
