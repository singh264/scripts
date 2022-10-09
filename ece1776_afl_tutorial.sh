#!/bin/bash

echo "ece1776_afl_tutorial.sh"

gnu_coreutils_program=""
directory_path=""

initialize_the_variables()
{
    for var in "$@"
    do
        key=$(echo $var | cut -d'=' -f1)
        value=$(echo $var | cut -d'=' -f2)

        if [ $key = '--gnu_coreutils_program' ]
        then
           gnu_coreutils_program=$value
        elif [ $key = '--directory_path' ]
	then
	    directory_path=$value
        fi
    done
}

build_afl() 
{
    cd $directory_path
    sudo apt-get install -y git
    git clone https://github.com/google/AFL.git
    cd $directory_path/AFL
    sudo apt-get -y update
    sudo apt-get -y install make
    sudo apt-get -y install gcc
    sudo make install
}

build_the_gnu_coreutils_program()
{
   cd $directory_path
   sudo apt-get install -y wget
   wget http://panda.moyix.net/~moyix/lava_corpus.tar.xz
   tar -xvf $directory_path/lava_corpus.tar.xz
   cd $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe
   sudo apt-get install -y libacl1-dev
   sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
   echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
   sed -i '1s/^/#include <sys\/sysmacros.h>\n/' lib/mountlist.c
   CC=/usr/local/bin/afl-gcc CXX=/usr/local/bin/afl-g++ $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe/configure --prefix=`pwd`/lava-install LIBS="-lacl"
   make clean all -j4
   make install
}

indicate_that_the_AFL_build_of_the_gnu_coreutils_program_includes_a_vulnerability()
{
   $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe/lava-install/bin/$gnu_coreutils_program -d $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/inputs/utmp-fuzzed-1.b64
}

generate_the_output_of_the_afl-fuzz_command_with_the_gnu_coreutils_program()
{
   cd $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program
   mkdir $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/outputs
   /usr/local/bin/afl-fuzz -i $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/fuzzer_input/ -o $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/outputs/ -- $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe/lava-install/bin/$gnu_coreutils_program -d
}

install_the_dependencies_to_create_the_AFL_coverage_of_the_gnu_coreutils_program()
{
   cd $directory_path
   wget http://ftp.gnu.org/gnu/m4/m4-1.4.13.tar.gz
   tar -xvf $directory_path/m4-1.4.13.tar.gz
   cd $directory_path/m4-1.4.13
   $directory_path/m4-1.4.13/configure
   sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
   echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
   sudo make install

   cd $directory_path
   wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
   tar -xvf $directory_path/autoconf-2.69.tar.gz
   cd $directory_path/autoconf-2.69
   $directory_path/autoconf-2.69/configure
   make
   sudo make install

   cd $directory_path
   wget https://mirror2.evolution-host.com/gnu/automake/automake-1.15.tar.gz
   tar -xvf $directory_path/automake-1.15.tar.gz
   cd $directory_path/automake-1.15
   $directory_path/automake-1.15/configure
   make
   sudo make install

   sudo apt-get install -y gperf

   cd $directory_path
   wget http://ftp.gnu.org/gnu/texinfo/texinfo-6.8.tar.gz
   tar -xvf $directory_path/texinfo-6.8.tar.gz
   cd $directory_path/texinfo-6.8
   $directory_path/texinfo-6.8/configure
   make
   sudo make install

   sudo apt-get install -y makeinfo
   sudo apt-get install -y python2
   sudo apt-get install -y lcov
}

create_the_AFL_coverage_of_the_gnu_coreutils_program()
{
   cd $directory_path
   git clone https://github.com/mrash/afl-cov.git
   cd $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program
   cp -r $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov
   cd $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov
   make clean distclean
   CFLAGS="-fprofile-arcs -ftest-coverage" $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov/configure --prefix=`pwd`/lava-install  LIBS="-lacl"
   make
   make install
}

generate_the_output_of_the_afl-cov_command_that_is_run_with_the_gnu_coreutils_program()
{
   cd $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov/lava-install/bin
   $directory_path/afl-cov/afl-cov -d $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/outputs --coverage-cmd "/bin/cat AFL_FILE | $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov/lava-install/bin/$gnu_coreutils_program -d" --code-dir $directory_path/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov/src
}

INPUT="$@"
initialize_the_variables $INPUT
gnu_coreutils_programs=( "base64" "md5sum" "uniq" "who" )
if [[ -z "$gnu_coreutils_program" || ! " ${gnu_coreutils_programs[@]} " =~ " $gnu_coreutils_program " ]]
then
    echo "Provide the gnu coreutils program that could be base64, md5sum, uniq and who."
    exit
fi
if [ -z "$directory_path" ]
then
    echo "Provide the directory path."
    exit
fi

build_afl
build_the_gnu_coreutils_program
indicate_that_the_AFL_build_of_the_gnu_coreutils_program_includes_a_vulnerability
generate_the_output_of_the_afl-fuzz_command_with_the_gnu_coreutils_program
install_the_dependencies_to_create_the_AFL_coverage_of_the_gnu_coreutils_program
create_the_AFL_coverage_of_the_gnu_coreutils_program
generate_the_output_of_the_afl-cov_command_that_is_run_with_the_gnu_coreutils_program
