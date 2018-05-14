#!/usr/bin/env bash
# Get resource IDs
RESOURCE_IDs=`aws apigateway get-resources --rest-api-id ${PRIVATE_CHAIN_REST_API_ID} \
        | jq -r '.items[] | select(.resourceMethods).id'`

# Set IAM authentications
for resource_id in ${RESOURCE_IDs}; do
  aws apigateway update-method --rest-api-id ${PRIVATE_CHAIN_REST_API_ID} \
    --resource-id ${resource_id} \
    --http-method POST \
    --patch-operations \
    op="replace",path="/authorizationType",value="AWS_IAM"
done

# Deployment
aws apigateway create-deployment --rest-api-id ${PRIVATE_CHAIN_REST_API_ID} \
    --stage-name production \
    --description "for enable IAM authentications"

# ---

# Delete unnecessary Stage "Stage"
# SAM's bug? https://github.com/awslabs/serverless-application-model/issues/168
aws apigateway delete-stage --rest-api-id ${PRIVATE_CHAIN_REST_API_ID} --stage-name Stage

# ---

# Enable logs
aws apigateway update-stage --rest-api-id ${PRIVATE_CHAIN_REST_API_ID} --stage-name 'production' --patch-operations op=replace,path=/*/*/logging/dataTrace,value=true
aws apigateway update-stage --rest-api-id ${PRIVATE_CHAIN_REST_API_ID} --stage-name 'production' --patch-operations op=replace,path=/*/*/logging/loglevel,value=INFO
aws apigateway update-stage --rest-api-id ${PRIVATE_CHAIN_REST_API_ID} --stage-name 'production' --patch-operations op=replace,path=/*/*/metrics/enabled,value=true
