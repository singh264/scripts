#!/bin/sh

rename_the_build_directory()
{
   DIRECTORY=$1
   date=$(echo "$(date '+%b%d')" | awk '{print tolower($1)}')
   mv $DIRECTORY "$DIRECTORY"_$date
}

DIRECTORY=openj9-openjdk-jdk8
if [ -d "$DIRECTORY" ]; then
   echo "$DIRECTORY exists"
   rename_the_build_directory $DIRECTORY
   exit
fi

git clone https://github.com/ibmruntimes/openj9-openjdk-jdk8.git 
cd $DIRECTORY
bash get_source.sh 
bash configure
make all
