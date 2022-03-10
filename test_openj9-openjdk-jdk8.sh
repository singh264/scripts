#!/bin/bash

echo "test_openj9-openjdk-jdk8.sh"

create_the_scripts_directory_path()
{
    mkdir -p $1/git
    cd $1/git
    git clone https://github.com/singh264/scripts.git
    cd $1
    echo "$1/git/scripts"
}

get_the_images_directory_path()
{
    if [ ! -d "$1/openj9-openjdk-jdk8" ]
    then
	scripts_directory_path=$(create_the_scripts_directory_path $1)
	bash $scripts_directory_path/build_openj9-openjdk-jdk8.sh
    fi

    if [ -d "$1/openj9-openjdk-jdk8/build/linux-ppc64le-normal-server-release/images" ]
    then
	echo "$1/openj9-openjdk-jdk8/build/linux-ppc64le-normal-server-release/images"
    elif [ -d "$1/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images" ]
    then
	echo "$1/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images"
    fi
}

DIRECTORY=$PWD
images_directory_path=$(get_the_images_directory_path $DIRECTORY)
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
