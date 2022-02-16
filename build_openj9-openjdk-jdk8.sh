#!/bin/sh

echo "build_openj9-openjdk-jdk8.sh"

boot_jdk_directory_path=""
freetype_include_directory_path=""
freetype_lib_directory_path=""

initialize_the_directory_paths()
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

rename_the_build_directory()
{
    date=$(echo "$(date '+%b%d')" | awk '{print tolower($1)}')
    mv $1 $1_$date
}

INPUT="$@"
DIRECTORY=$PWD
build_directory="$DIRECTORY/openj9-openjdk-jdk8"
if [ -d $build_directory ]; then
    echo "$build_directory exists"
    rename_the_build_directory $build_directory
fi

git clone https://github.com/ibmruntimes/openj9-openjdk-jdk8.git 
cd $build_directory
bash get_source.sh 
initialize_the_directory_paths $INPUT
bash configure --with-boot-jdk=$boot_jdk_directory_path --with-freetype-include=$freetype_include_directory_path --with-freetype-lib=$freetype_lib_directory_path
make all
