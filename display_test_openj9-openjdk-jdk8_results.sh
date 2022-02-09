#!/bin/bash

echo "display_test_openj9-openjdk-jdk8_results.sh"

openj9_branch=""

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

install_git()
{   
    OS=$(uname -s)
    if [ $OS = "Darwin" ]
    then
        echo "Install git on macOS."
        brew install git
    elif [ $OS = "Linux" ]
    then
        echo "Install git on Linux."
        sudo apt-get install git
    fi
}

create_the_scripts_directory_path()
{   
    mkdir -p $1/git
    cd $1/git
    git clone https://github.com/singh264/scripts.git
    cd $1
    echo "$1/git/scripts"
}

display_the_test_openj9-openjdk-jdk8_results()
{
    if [ -d "$1/aqa-tests/TKG/output_compilation" ]
    then
	vim $1/aqa-tests/TKG/output_compilation/compilation.log
    else
	vim $1/aqa-tests/TKG/output_*/Test_*
    fi
}

INPUT="$@"
initialize_the_openj9_branch $INPUT
if [ -z "$openj9_branch" ]
then
    echo "openj9 branch absent"
    exit
fi

install_git

DIRECTORY=$PWD
scripts_directory_path=$(create_the_scripts_directory_path $DIRECTORY)
bash $scripts_directory_path/install_openj9-openjdk-jdk8_dependencies.sh
bash $scripts_directory_path/build_openj9-openjdk-jdk8.sh --with-boot-jdk=/home/user/jdk8u312-b07 --with-freetype-include=/usr/include/freetype2 --with-freetype-lib=/usr/lib/x86_64-linux-gnu
bash $scripts_directory_path/openj9_checkout_remote_branch.sh $openj9_branch
cd $DIRECTORY/openj9-openjdk-jdk8
make all
cd $DIRECTORY
bash $scripts_directory_path/test_openj9-openjdk-jdk8.sh
display_the_test_openj9-openjdk-jdk8_results $DIRECTORY
