#!/bin/bash

echo "openj9_checkout_new_branch.sh"

#DIRECTORY="/Users/amar/git/openj9"
#cd $DIRECTORY
#A=$(git status)
#for var in $A
#do
#   echo $var
#   if [ $var == "branch" ]
#   then
#      echo "branch"
#   fi
#done
#B=0
#for var in $A
#do
#   if [ $var == "branch" ]
#   then
#      B=1
#   fi
#
#   if [ $B == 1 ]
#   then
#      echo "$var"
#   fi
#   
#   echo $B
#   
#   echo $var
#
#   echo "$var"
#done
#B=""
#for var in $A
#do
#   if [ "$B" = "branch" ]
#   then
#      echo $var
#   fi
#   
#   if [ $var == "branch" ]
#   then
#      B="branch"
#   fi
#done
#B=""
#for var in $A
#do
#   if [ "$B" = "branch" ]
#   then
#      echo $var
#      B=""
#   fi
#   
#   if [ $var == "branch" ]
#   then
#      B="branch"
#   fi
#done
#B=""
#for var in $A
#do
#   if [ "$B" = "branch" ]
#   then
#      B=$var
#      echo $B
#   fi
#
#   if [ $var == "branch" ]
#   then
#      B="branch"
#   fi
#done
#echo $B
#
#VAR="08"
#let "VAR=10#${VAR}"
#echo $VAR
#
##git fetch --prune upstream; git rebase -i upstream/master; git log

#echo "$#"
#if [ "$#" -ne 1 ]
#then
#   echo "branch absent"
#   exit
#fi
#
#BRANCH=$1
#DIRECTORY="/Users/amar/git/openj9"
#cd $DIRECTORY
##date()
#date=$(echo "$(date '+%b%d')" | awk '{print tolower($1)}')
## remote branch
#git checkout -b "$BRANCH"_$date
#git fetch --prune upstream
#git rebase -i upstream/master
#git log

#echo "$1"
#echo "$PWD"

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
git fetch --prune upstream
git rebase -i upstream/master

git log

cd -
