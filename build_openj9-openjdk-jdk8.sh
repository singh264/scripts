#!/bin/sh

echo "build_openj9-openjdk-jdk8.sh"

boot_jdk_directory_path=""
freetype_include_directory_path=""
freetype_lib_directory_path=""

obtain_the_directory_paths()
{
    for var in "$@"
    do
        key=$(echo $var | cut -d'=' -f1)
        value=$(echo $var | cut -d'=' -f2)

        if [ "$key" == "--with-boot-jdk" ]
        then
	    boot_jdk_directory_path=$value
        elif [ "$key" == "--with-freetype-include" ]
        then
	    freetype_include_directory_path=$value
        elif [ "$key" == "--with-freetype-lib" ]
        then
	    freetype_lib_directory_path=$value
        fi
    done
}

initialize_the_directory_paths_that_are_absent()
{
    if [[ ! -d $boot_jdk_directory_path || \
	  ! -d $freetype_include_directory_path || \
	  ! -d $freetype_lib_directory_path ]]
    then
	scripts_directory_path=$(create_the_scripts_directory_path $1)
	bash $scripts_directory_path/install_openj9-openjdk-jdk8_dependencies.sh
    fi

    if [ ! -d $boot_jdk_directory_path ]
    then
	boot_jdk_directory_path=$1/jdk8u312-b07
    fi

    if [ ! -d $freetype_include_directory_path ]
    then
	freetype_include_directory_path=/usr/include/freetype2
    fi

    if [ ! -d $freetype_lib_directory_path ]
    then
	freetype_lib_directory_path=/usr/lib/x86_64-linux-gnu
    fi
}

rename_the_build_directory()
{
    date=$(echo "$(date '+%b%d')" | awk '{print tolower($1)}')
    mv $1 $1_$date
}

create_the_scripts_directory_path()
{
    mkdir -p $1/git
    cd $1/git
    git clone https://github.com/singh264/scripts.git
    cd $1
    echo "$1/git/scripts"
}

INPUT="$@"
DIRECTORY=$PWD
obtain_the_directory_paths $INPUT
initialize_the_directory_paths_that_are_absent $DIRECTORY
build_directory="$DIRECTORY/openj9-openjdk-jdk8"
if [ -d $build_directory ]; then
    echo "$build_directory exists"
    rename_the_build_directory $build_directory
fi

git clone https://github.com/ibmruntimes/openj9-openjdk-jdk8.git 
cd $build_directory
bash get_source.sh 
bash configure --with-boot-jdk=$boot_jdk_directory_path --with-freetype-include=$freetype_include_directory_path --with-freetype-lib=$freetype_lib_directory_path
make all
