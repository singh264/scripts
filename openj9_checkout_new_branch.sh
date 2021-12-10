#!/bin/bash

if [ "$#" -ne 1 ]
then
   echo "branch absent"
   exit
fi

BRANCH=$1
DIRECTORY="openj9-openjdk-jdk8/openj9"
cd $PWD/$DIRECTORY
#date()
date=$(echo "$(date '+%b%d')" | awk '{print tolower($1)}')
git checkout -b "$BRANCH"_$date
#git remote add $NAME $URL
git fetch --prune upstream
git rebase -i upstream/master

git log

cd -
