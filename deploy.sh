#!/usr/bin/env bash

SSM_PARAMS_PREFIX=${ALIS_APP_ID}ssm

aws cloudformation deploy \
  --template-file template.yaml \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    ParityNodesAMI=${SSM_PARAMS_PREFIX}ParityNodesAMI \
    BastionAllocationId=${SSM_PARAMS_PREFIX}BastionAllocationId \
    NatAllocationId=${SSM_PARAMS_PREFIX}NatAllocationId \
    EC2DeleteOnTermination=${SSM_PARAMS_PREFIX}EC2DeleteOnTermination \
    AccountsNewRequestPassword=${SSM_PARAMS_PREFIX}AccountsNewRequestPassword \
    ParityNodesInstanceType=${SSM_PARAMS_PREFIX}ParityNodesInstanceType \
    ParityNodesVolumeSize=${SSM_PARAMS_PREFIX}ParityNodesVolumeSize \
    PrivateChainMainSigner=${SSM_PARAMS_PREFIX}PrivateChainMainSigner \
    PrivateChainAlisTokenAddress=${SSM_PARAMS_PREFIX}PrivateChainAlisTokenAddress \
    PrivateChainBridgeAddress=${SSM_PARAMS_PREFIX}PrivateChainBridgeAddress \
  --stack-name ${ALIS_APP_ID}privatechain
