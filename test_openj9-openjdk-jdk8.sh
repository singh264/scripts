#!/bin/bash

echo "test_openj9-openjdk-jdk8.sh"

images_directory_path=""

initialize_the_images_directory_path()
{
    DIRECTORY=$PWD
    if [ -d "$DIRECTORY/openj9-openjdk-jdk8/build/linux-ppc64le-normal-server-release/images" ]
    then
	images_directory_path="$DIRECTORY/openj9-openjdk-jdk8/build/linux-ppc64le-normal-server-release/images"
    elif [ -d "$DIRECTORY/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images" ]
    then
	images_directory_path="$DIRECTORY/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images"
    fi
}

initialize_the_images_directory_path
COMPILE_JDK_HOME=$images_directory_path/j2sdk-image
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

export TEST_JDK_HOME=$images_directory_path/j2sdk-image
export NATIVE_TEST_LIBS=$images_directory_path/test/openj9
make _sanity.functional
