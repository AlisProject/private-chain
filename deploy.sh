#!/usr/bin/env bash
aws cloudformation deploy \
  --template-file template.yaml \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    ParityNodesAMI=${ALIS_APP_ID}ssmParityNodesAMI \
    BastionAllocationId=${ALIS_APP_ID}ssmBastionAllocationId \
    NatAllocationId=${ALIS_APP_ID}ssmNatAllocationId \
    EC2DeleteOnTermination=${ALIS_APP_ID}ssmEC2DeleteOnTermination \
    AccountsNewRequestPassword=${ALIS_APP_ID}ssmAccountsNewRequestPassword \
    ParityNodesInstanceType=${ALIS_APP_ID}ssmParityNodesInstanceType \
    ParityNodesVolumeSize=${ALIS_APP_ID}ssmParityNodesVolumeSize \
    PrivateChainMainSigner=${ALIS_APP_ID}ssmPrivateChainMainSigner \
    PrivateChainAlisTokenAddress=${ALIS_APP_ID}ssmPrivateChainAlisTokenAddress \
  --stack-name ${ALIS_APP_ID}privatechain
