#!/bin/sh

DIRECTORY=openj9-openjdk-jdk8
if [ -d "$DIRECTORY" ]; then
   echo "$DIRECTORY exists"
   #mv openj9-openjdk-jdk8 openj9-openjdk-jdk8_dec3 
   exit
fi

git clone https://github.com/ibmruntimes/openj9-openjdk-jdk8.git 
cd openj9-openjdk-jdk8 
bash get_source.sh 
bash configure
make all
