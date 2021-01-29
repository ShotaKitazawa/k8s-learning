#!/bin/bash -eu -o pipefail

#set -x

cd $(dirname $0)

INSTANCE=k8s-learning
NETWORK=k8s-learning
REGION=asia-northeast1
ZONE=$REGION-a
IMAGE_FAMILY=ubuntu-1804-lts
IMAGE_PROJECT=ubuntu-os-cloud

PROJECT=$(gcloud config list 2>&1 | grep project | cut -d" " -f3)
echo -n "current_project is $PROJECT: ok? [y/n]: "; read check
if [ "$check" != "y" ]; then
  echo 'please set other project > `gcloud config set project $PROJECT`'
  exit 1
fi

case $1 in
  "create" )
    if [ "$NAMES" = "" ]; then echo "NAMES is undefined"; exit 1; fi
    if [ ! -e .state ]; then echo "$NAMES" > .state; else echo ".state exists"; exit 1; fi
    gcloud compute networks create $NETWORK --subnet-mode custom --project=$PROJECT
    gcloud compute firewall-rules create $NETWORK --network=$NETWORK --rules tcp:22 --action allow --project=$PROJECT
    startup='#! /bin/bash
    # Install python3
    sudo su -
    apt update
    apt -y install python3'
    cnt=0
    for name in $NAMES; do
      cnt=$(($cnt+1))
      range=10.$cnt.0.0/24
      gcloud compute networks subnets create $NETWORK-$name --network=$NETWORK --range=$range --region $REGION --project=$PROJECT
      gcloud compute firewall-rules create $NETWORK-$name --network=$NETWORK --source-ranges=$range --rules all --action allow --project=$PROJECT
      gcloud compute instances create $INSTANCE-$name-01 --image-family $IMAGE_FAMILY --image-project $IMAGE_PROJECT --subnet $NETWORK-$name --zone $ZONE --project=$PROJECT --metadata startup-script="$startup"
      gcloud compute instances create $INSTANCE-$name-02 --image-family $IMAGE_FAMILY --image-project $IMAGE_PROJECT --subnet $NETWORK-$name --zone $ZONE --project=$PROJECT --metadata startup-script="$startup"
      gcloud compute instances create $INSTANCE-$name-03 --image-family $IMAGE_FAMILY --image-project $IMAGE_PROJECT --subnet $NETWORK-$name --zone $ZONE --project=$PROJECT --metadata startup-script="$startup"
    done
    ;;
  "delete")
    if [ -e .state ]; then NAMES="$(cat .state)"; else echo ".state dont exist"; exit 1; fi
    for name in $NAMES; do
      gcloud compute instances delete $INSTANCE-$name-01 --zone $ZONE -q --project=$PROJECT
      gcloud compute instances delete $INSTANCE-$name-02 --zone $ZONE -q --project=$PROJECT
      gcloud compute instances delete $INSTANCE-$name-03 --zone $ZONE -q --project=$PROJECT
      gcloud compute firewall-rules delete $NETWORK-$name -q --project=$PROJECT
      gcloud compute networks subnets delete $NETWORK-$name --region $REGION -q --project=$PROJECT
    done
    gcloud compute firewall-rules delete $NETWORK -q --project=$PROJECT
    gcloud compute networks delete $NETWORK -q --project=$PROJECT
    rm -f .state
    ;;
  *)
    echo "invalid argument"
    exit 1
    ;;
esac
