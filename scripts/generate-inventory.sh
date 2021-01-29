#!/bin/bash

set -e

cd $(dirname $0)

REGION=asia-northeast1
ZONE=$REGION-a
SSH_USER=ubuntu

instances="$(gcloud compute instances list --filter='name:k8s-learning-*' --format='value(name,EXTERNAL_IP)' | perl -pe 's|^(.*)\t(.*)$|$1 ansible_ssh_host=$2|g')"
# TODO 余計な出力が出てしまうのを修正する
ssh_user=$(gcloud compute ssh --zone='asia-northeast1-a' ${SSH_USER}@$(echo "${instances}" | head -n1 | cut -d" " -f1) -- sh -c "whoami")

cat << _EOF_ > ./inventory
[master]
$(echo "${instances}" | grep -- -01)

[node]
$(echo "${instances}")

[all:vars]
ansible_ssh_user=${ssh_user}
_EOF_
