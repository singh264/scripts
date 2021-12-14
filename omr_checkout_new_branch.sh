#!/bin/bash

echo "omr_checkout_new_branch.sh"

if [ "$#" -ne 1 ]
then
   echo "branch absent"
   exit
fi

BRANCH=$1
DIRECTORY="openj9-openjdk-jdk8/omr"
cd $PWD/$DIRECTORY
date=$(echo "$(date '+%b%d')" | awk '{print tolower($1)}')
git checkout -b "$BRANCH"_$date
git fetch --prune upstream
git rebase -i upstream/master

git log

cd -
