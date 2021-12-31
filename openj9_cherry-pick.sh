#!/bin/sh

install_wget()
{
    OS=$(uname -s)
    if [[ "$OS" == "Darwin" ]]
    then
	echo "Install wget on macOS."
	brew install wget
    elif [[ "$OS" == "Linux" ]]
    then
        echo "Install wget on Linux."
        sudo apt-get install wget
    fi
}

if [ "$#" -ne 1 ]
then
    echo "commit absent"
    exit
fi

install_wget

COMMIT=$1
DIRECTORY=$PWD
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
    fi
done

cd $DIRECTORY/openj9-openjdk-jdk8/openj9

git log
