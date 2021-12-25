#!/bin/bash

if [ $# -ne 1 ]; then
    echo "      $0 <ENV_TYPE(dev|stg|prod)>"
    exit 1
elif [ "$1" != "dev" -a "$1" != "stg" -a "$1" != "prod" ]; then
    echo "      $0 <ENV_TYPE(dev|stg|prod)>"
    exit 1
fi

cd `dirname $0`

SYSTEM_NAME=TestDocker
ENV_TYPE=$1

delete_stack () {
    STACK_NAME=$1
    aws cloudformation delete-stack \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --profile ${SYSTEM_NAME}-${ENV_TYPE}

    aws cloudformation wait stack-delete-complete \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --profile ${SYSTEM_NAME}-${ENV_TYPE}
}

#####################################
# CI/CD
#####################################
# delete_stack code-pipeline
# delete_stack s3
# delete_stack code-build
# delete_stack code-commit

#####################################
# Container
#####################################
# delete_stack event-bridge
# delete_stack step-functions
# delete_stack ecs
# delete_stack ecr

#####################################
# 共通
#####################################
# delete_stack sns
# delete_stack endpoint
# delete_stack sg
# delete_stack network
# delete_stack iam

exit 0