#!/bin/bash

create_the_new_branch()
{
    date=$(echo "$(date '+%b%d')" | awk '{print tolower($1)}')
    git checkout -b $1_$date
}

if [ "$#" -ne 1 ]
then
    echo "branch absent"
    exit
fi

BRANCH=$1
DIRECTORY="openj9-openjdk-jdk8/openj9"
cd $PWD/$DIRECTORY
create_the_new_branch $BRANCH
git remote add upstream git@github.com:eclipse-openj9/openj9.git
git fetch --prune upstream
git rebase -i upstream/master

git log

cd -
