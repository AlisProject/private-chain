#!/usr/bin/env bash

# For Bastion server
BASTION=EIPBastion-${ALIS_APP_ID}
aws ec2 allocate-address --domain vpc \
  | jq '.AllocationId' \
  | xargs aws ec2 create-tags --tags Key=Name,Value=${BASTION} Key=Component,Value=PrivateChain --resources


# For NAT
NAT=EIPNAT-${ALIS_APP_ID}
aws ec2 allocate-address --domain vpc \
  | jq '.AllocationId' \
  | xargs aws ec2 create-tags --tags Key=Name,Value=${NAT} Key=Component,Value=PrivateChain --resources

echo ""
echo "You have to specify SSM valuables of EIP:"
echo ""
echo ${BASTION}
echo ${NAT}
echo ""
