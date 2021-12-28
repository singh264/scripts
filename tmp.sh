#!/bin/bash

echo "openj9_checkout_new_branch.sh"

create_the_new_branch()
{
    date=$(echo "$(date '+%b%d')" | awk '{print tolower($1)}')
    #git checkout -b "$1"_$date
    git checkout -b "$BRANCH"_$date
}

if [ "$#" -ne 1 ]
then
    echo "branch absent"
    exit
fi

BRANCH=$1
DIRECTORY="openj9-openjdk-jdk8/openj9"
cd $PWD/$DIRECTORY
#create_the_new_branch $BRANCH
create_the_new_branch
git remote add upstream git@github.com:eclipse-openj9/openj9.git
git fetch --prune upstream
git rebase -i upstream/master

git log

cd -
