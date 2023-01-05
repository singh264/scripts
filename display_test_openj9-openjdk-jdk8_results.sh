#!/bin/bash

echo "display_test_openj9-openjdk-jdk8_results.sh"

openj9_branch=""
directory_path=$PWD

initialize_the_openj9_branch()
{
    for var in "$@"
    do
        key=$(echo $var | cut -d'=' -f1)
        value=$(echo $var | cut -d'=' -f2)

        if [ $key = '--openj9-branch' ]
        then
	   openj9_branch=$value
        fi
    done
}

install_openj9-openjdk-jdk8_dependencies()
{
    cd $directory_path

    sudo apt-get update \
        && sudo apt-get install -qq -y --no-install-recommends \
           software-properties-common \
        && sudo add-apt-repository ppa:ubuntu-toolchain-r/test \
        && sudo apt-get update \
        && sudo apt-get install -qq -y --no-install-recommends \
           ant \
           ant-contrib \
           autoconf \
           build-essential \
           ca-certificates \
           cmake \
           cpio \
           curl \
           file \
           g++-7 \
           gcc-7 \
           gdb \
           git \
           libasound2-dev \
           libcups2-dev \
           libdwarf-dev \
           libelf-dev \
           libexpat1-dev \
           libffi-dev \
           libfontconfig \
           libfontconfig1-dev \
           libfreetype6-dev \
           libnuma-dev \
           libssl-dev \
           libx11-dev \
           libxext-dev \
           libxrandr-dev \
           libxrender-dev \
           libxt-dev \
           libxtst-dev \
           make \
           nasm \
           openssh-client \
           openssh-server \
           perl \
           pkg-config \
           ssh \
           systemtap-sdt-dev \
           unzip \
           wget \
           xvfb \
           zip \
           zlib1g-dev \
        && sudo rm -rf /var/lib/apt/lists/*

    export CC=gcc-7 CXX=g++-7

    wget https://sourceforge.net/projects/freemarker/files/freemarker/2.3.8/freemarker-2.3.8.tar.gz/download -O freemarker.tgz
    tar -xzf freemarker.tgz freemarker-2.3.8/lib/freemarker.jar --strip-components=2

    wget -O bootjdk8.tar.gz "https://api.adoptopenjdk.net/v3/binary/latest/8/ga/linux/x64/jdk/openj9/normal/adoptopenjdk"
    tar -xzf $directory_path/bootjdk8.tar.gz
    mkdir $directory_path/tmp/
    mv $directory_path/bootjdk8.tar.gz $directory_path/tmp/
    mv $(ls $directory_path | grep -i jdk8u) $directory_path/bootjdk8

    git clone https://github.com/ibmruntimes/openj9-openjdk-jdk8.git
}

build_openj9-openjdk-jdk8()
{
    cd $directory_path/openj9-openjdk-jdk8/
    bash $directory_path/openj9-openjdk-jdk8/get_source.sh
    make clean
    bash $directory_path/openj9-openjdk-jdk8/configure --with-boot-jdk=$directory_path/bootjdk8
    make all
}

check_openj9-openjdk-jdk8()
{
    cd $directory_path/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images/j2re-image/
    $directory_path/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images/j2re-image/bin/java -version
}

openj9_checkout_remote_branch()
{
    cd $directory_path/openj9-openjdk-jdk8/openj9/
    git remote add local https://github.com/singh264/openj9.git
    git fetch --prune local
    git checkout -b $openj9_branch local/$openj9_branch
    git reset --hard local/$openj9_branch
}

obtain_the_branch_in_the_build()
{
    cd $directory_path/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images/test/openj9/
    echo $directory_path/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images/test/openj9/java-version.txt | grep $openj9_branch | cut -d' ' -f5 | cut -d'-' -f1
}

test_openj9-openjdk-jdk8()
{
    cd $directory_path
    export TEST_JDK_HOME=$directory_path/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images/j2sdk-image
    export BUILD_LIST=functional
    git clone https://github.com/adoptium/aqa-tests.git
    cd $directory_path/aqa-tests/
    bash $directory_path/aqa-tests/get.sh
    cd $directory_path/aqa-tests/TKG/
    make clean
    make compile
    export NATIVE_TEST_LIBS=$directory_path/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images/test/openj9
    make _sanity.functional
}

display_the_test_openj9-openjdk-jdk8_results()
{
    if [ -d "$directory_path/aqa-tests/TKG/output_compilation" ]
    then
	vim $directory_path/aqa-tests/TKG/output_compilation/compilation.log
    else
	vim $directory_path/aqa-tests/TKG/output_*/Test_*
    fi
}

INPUT="$@"
initialize_the_openj9_branch $INPUT
if [ -z "$openj9_branch" ]
then
    echo "openj9 branch absent"
    exit
fi

install_openj9-openjdk-jdk8_dependencies
build_openj9-openjdk-jdk8
check_openj9-openjdk-jdk8
openj9_checkout_remote_branch
build_openj9-openjdk-jdk8

branch=$(obtain_the_branch_in_the_build $openj9_branch)
if [[ -z "$branch" || $branch != $openj9_branch ]]
then
    echo "The build could not complete with the openj9 branch $openj9_branch"
    exit
fi

test_openj9-openjdk-jdk8
display_the_test_openj9-openjdk-jdk8_results
