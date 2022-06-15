#!/usr/bin/env bash

CICD_IMAGE=cicd-environment

docker run -it -v ${PWD}:/src \
    --rm \
    --privileged \
    --entrypoint "/bin/bash" \
    --workdir /src \
    --env AWS_PAGER='' \
    --env AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} \
    --env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    --env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    --env AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN} \
    --env AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID} \
    ${CICD_IMAGE}
