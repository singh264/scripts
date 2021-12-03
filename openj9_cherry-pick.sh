#!/bin/sh

cd /home/amar/cache_the_result_of_objectAlignmentInBytes/openj9-openjdk-jdk8/openj9
git remote add local https://github.com/singh264/openj9.git
git fetch --prune local
git cherry-pick $1
A=$(git reset HEAD^1)
git diff
B=$(git reset HEAD@{1})

C=( "cpp" "hpp" )
for var in $A
do
   file=$(echo "$var" | rev | cut -d'.' -f1 | rev)
   if [[ " ${C[@]} " =~ " $file " ]]
   then
      file=$(echo "$var" | rev | cut -d'/' -f1 | rev)
      vimdiff /home/amar/cache_the_result_of_objectAlignmentInBytes/$file /home/amar/cache_the_result_of_objectAlignmentInBytes/openj9-openjdk-jdk8/openj9/$var
   fi
done

git log
