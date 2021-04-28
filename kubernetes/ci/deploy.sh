	#!/bin/bash

set -x

all_branch=$(git branch -a | grep k8s- | grep remotes | awk -F '/' '{print $3}' | grep '^k8s')
all_namespace=$(kubectl get namespace | grep k8s- | awk '{print $1}')
if [ $BRANCH_NAME == master ];then
    eval \\"echo \"$(cat charts-*.yaml | sed 's#\"#\\"#g')\"\\" | kubectl apply -f -
    for namespace in ${all_namespace}; do
        if ! echo ${all_branch} | grep $namespace >> /dev/null; then
            export BRANCH_NAME=${namespace}
            eval \\"echo \"$(cat backend-*.yaml | sed 's#\"#\\"#g')\"\\" | kubectl apply -f -
            echo "------------------${namespace} update master image  successful---------------------"
        fi
    done
else
    eval \\"echo \"$(cat charts-*.yaml | sed 's#\"#\\"#g')\"\\" | kubectl apply -f -
fi
