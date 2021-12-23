#!/bin/bash

if [ "$#" -ne 1 ]
then
    echo "upstream branch absent"
    exit
fi

BRANCH=$1
DIRECTORY="openj9-openjdk-jdk8/openj9"
cd $PWD/$DIRECTORY
git remote add upstream git@github.com:eclipse-openj9/openj9.git
git fetch --prune upstream
git checkout -b $BRANCH upstream/$BRANCH
git reset --hard upstream/$BRANCH

git log

cd -
