#!/bin/sh

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

create_stack () {
    STACK_NAME=$1
    aws cloudformation create-stack \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --template-body file://./${SYSTEM_NAME}/${STACK_NAME}/${STACK_NAME}.yml \
    --cli-input-json file://./${SYSTEM_NAME}/${STACK_NAME}/${ENV_TYPE}-parameters.json \
    --profile ${SYSTEM_NAME}-${ENV_TYPE}

    aws cloudformation wait stack-create-complete \
    --stack-name ${SYSTEM_NAME}-${ENV_TYPE}-${STACK_NAME} \
    --profile ${SYSTEM_NAME}-${ENV_TYPE}
}

#####################################
# 共通
#####################################
# create_stack iam
# create_stack network
# create_stack sg

#####################################
# Container
#####################################
# create_stack ecr
# create_stack ecs
# create_stack step-functions
# create_stack event-bridge

#####################################
# CI/CD
#####################################
# create_stack sns
# create_stack code-commit
# create_stack code-build
# create_stack code-pipeline

exit 0