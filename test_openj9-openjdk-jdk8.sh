#!/bin/bash

echo "test_openj9-openjdk-jdk8.sh"

DIRECTORY=$PWD
COMPILE_JDK_HOME=$DIRECTORY/openj9-openjdk-jdk8/build/linux-ppc64le-normal-server-release/images/j2sdk-image
if [ $# -eq 1 ]
then
    COMPILE_JDK_HOME=$1
fi

export TEST_JDK_HOME=$COMPILE_JDK_HOME
export BUILD_LIST=functional
git clone https://github.com/adoptium/aqa-tests.git
cd $DIRECTORY/aqa-tests
bash $DIRECTORY/aqa-tests/get.sh
cd $DIRECTORY/aqa-tests/TKG
make clean
make compile

export TEST_JDK_HOME=$DIRECTORY/openj9-openjdk-jdk8/build/linux-ppc64le-normal-server-release/images/j2sdk-image
make _sanity.functional
