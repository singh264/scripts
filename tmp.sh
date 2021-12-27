#!/bin/bash

echo "omr_checkout_upstream_branch.sh"

if [ "$#" -ne 1 ]
then
    echo "upstream branch absent"
    exit
fi

BRANCH=$1
DIRECTORY="openj9-openjdk-jdk8/omr"
cd $PWD/$DIRECTORY
git remote add upstream git@github.com:eclipse/omr.git
git fetch --prune upstream
git checkout -b $BRANCH upstream/$BRANCH
git reset --hard upstream/$BRANCH

git log

cd -
