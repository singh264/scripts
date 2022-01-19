#!/bin/bash

echo "openj9_checkout_remote_branch.sh"

if [ "$#" -ne 1 ]
then
    echo "remote branch absent"
    exit
fi

BRANCH=$1
DIRECTORY="openj9-openjdk-jdk8/openj9"
cd $PWD/$DIRECTORY
git remote add local git@github.com:singh264/openj9.git
git fetch --prune local
git checkout -b $BRANCH local/$BRANCH
git reset --hard local/$BRANCH

git log

cd -
