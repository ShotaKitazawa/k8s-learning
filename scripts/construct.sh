#!/bin/bash

set -x

cd $(dirname $0)

ARG=${1}

INSTANCE=k8s-learning
NETWORK=k8s-learning
REGION=asia-northeast1
ZONE=$REGION-a
IMAGE_FAMILY=ubuntu-1804-lts
IMAGE_PROJECT=ubuntu-os-cloud

PROJECT=$(gcloud config list 2>&1 | grep project | cut -d" " -f3)
echo "current_project is $PROJECT: ok? [y/n]: "; read check
if [ "$check" != "y" ]; then exit 1; fi

if [ "$ARG" = "create" ]; then
  if [ "$NAMES" = "" ]; then echo "NAMES is undefined"; exit 1; fi
  if [ ! -e .state ]; then echo "$NAMES" > .state; else echo ".state exists"; exit 1; fi
  gcloud config set project $PROJECT
  gcloud compute networks create $NETWORK --subnet-mode custom
  gcloud compute firewall-rules create $NETWORK --network=$NETWORK --rules tcp:22 --action allow
  cnt=0
  for name in $NAMES; do
    cnt=$(($cnt+1))
    range=10.$cnt.0.0/24
    gcloud compute networks subnets create $NETWORK-$name --network=$NETWORK --range=$range --region $REGION
    gcloud compute firewall-rules create $NETWORK-$name --network=$NETWORK --source-ranges=$range --rules all --action allow
    gcloud compute instances create $INSTANCE-$name-01 --image-family $IMAGE_FAMILY --image-project $IMAGE_PROJECT --subnet $NETWORK-$name --zone $ZONE
    gcloud compute instances create $INSTANCE-$name-02 --image-family $IMAGE_FAMILY --image-project $IMAGE_PROJECT --subnet $NETWORK-$name --zone $ZONE
    gcloud compute instances create $INSTANCE-$name-03 --image-family $IMAGE_FAMILY --image-project $IMAGE_PROJECT --subnet $NETWORK-$name --zone $ZONE
  done
elif [ "$ARG" = "delete" ]; then
  if [ -e .state ]; then NAMES="$(cat .state)"; else echo ".state dont exist"; exit 1; fi
  gcloud config set project $PROJECT
  for name in $NAMES; do
    gcloud compute instances delete $INSTANCE-$name-01 -q
    gcloud compute instances delete $INSTANCE-$name-02 -q
    gcloud compute instances delete $INSTANCE-$name-03 -q
    gcloud compute firewall-rules delete $NETWORK-$name -q
    gcloud compute networks subnets delete $NETWORK-$name --region $REGION -q
  done
  gcloud compute firewall-rules delete $NETWORK -q
  gcloud compute networks delete $NETWORK -q
  rm -f .state
else
  echo "invalid argument"
fi
