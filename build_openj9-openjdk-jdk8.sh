#!/bin/sh

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
    DIRECTORY=$1
    date=$(echo "$(date '+%b%d')" | awk '{print tolower($1)}')
    mv $DIRECTORY "$DIRECTORY"_$date
}

INPUT="$@"
DIRECTORY=openj9-openjdk-jdk8
if [ -d "$DIRECTORY" ]; then
    echo "$DIRECTORY exists"
    rename_the_build_directory $DIRECTORY
fi

git clone https://github.com/ibmruntimes/openj9-openjdk-jdk8.git 
cd openj9-openjdk-jdk8 
bash get_source.sh 
initialize_the_directory_paths $INPUT
bash configure --with-boot-jdk=$boot_jdk_directory_path --with-freetype-include=$freetype_include_directory_path --with-freetype-lib=$freetype_lib_directory_path
make all
