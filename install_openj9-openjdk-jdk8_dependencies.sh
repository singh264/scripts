#!/bin/bash

echo "install_openj9-openjdk-jdk8_dependencies.sh"

apt-get_install_dependencies()
{
    sudo apt-get update
    
    sudo apt-get install \
        make \
        cmake \
        nasm \
        unzip \
        zip \
        wget \
        build-essential \
        libxext-dev \
        libxrender-dev \
        libxtst-dev \
        libxt-dev \
        libcups2-dev \
        libfreetype6-dev \
        libasound2-dev \
        libfontconfig1-dev \
        libelf-dev \
        libdwarf-dev \
        m4 \
        libnuma-dev \
        ant \
        git \
        screen 
}

wget_download_dependencies()
{
    wget https://github.com/ibmruntimes/semeru8-binaries/releases/download/jdk8u312-b07_openj9-0.29.0/ibm-semeru-open-jdk_x64_linux_8u312b07_openj9-0.29.0.tar.gz
    tar -xvf $DIRECTORY/ibm-semeru-open-jdk_x64_linux_8u312b07_openj9-0.29.0.tar.gz 

    wget https://repo1.maven.org/maven2/ant-contrib/ant-contrib/1.0b3/ant-contrib-1.0b3.jar
    sudo cp $DIRECTORY/ant-contrib-1.0b3.jar /usr/share/ant/lib/
}

DIRECTORY=$PWD
cd $DIRECTORY
apt-get_install_dependencies
wget_download_dependencies
