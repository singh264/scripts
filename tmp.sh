#!/bin/bash

echo "openj9_cherry-pick.sh"

if [ "$#" -ne 1 ]
then
    echo "commit absent"
    exit
fi

#brew install wget

COMMIT=$1
DIRECTORY=/home/amar/cache_the_result_of_objectAlignmentInBytes
#DIRECTORY=$PWD
cd $DIRECTORY/openj9-openjdk-jdk8/openj9
git remote add local https://github.com/singh264/openj9.git
git fetch --prune local
git cherry-pick $COMMIT
A=$(git reset HEAD^1)
git diff
B=$(git reset HEAD@{1})
cd $DIRECTORY

C=( "cpp" "hpp" )
for var in $A
do
    file=$(echo "$var" | rev | cut -d'.' -f1 | rev)
    if [[ " ${C[@]} " =~ " $file " ]]
    then
	file=$(echo "$var" | rev | cut -d'/' -f1 | rev)
	rm $file $file.*
	wget https://raw.githubusercontent.com/eclipse-openj9/openj9/master/$var
	sleep 5
	vimdiff $DIRECTORY/$file $DIRECTORY/openj9-openjdk-jdk8/openj9/$var
	#vimdiff $file $var
    fi
done

git log
