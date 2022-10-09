#!/bin/bash

echo "ece1776_afl_tutorial.sh"

gnu_coreutils_program=""

initialize_the_gnu_coreutils_program()
{
    for var in "$@"
    do
        key=$(echo $var | cut -d'=' -f1)
        value=$(echo $var | cut -d'=' -f2)

        if [ $key = '--gnu_coreutils_program' ]
        then
           gnu_coreutils_program=$value
        fi
    done
}

build_afl() 
{
    sudo apt-get install -y git
    git clone https://github.com/google/AFL.git
    cd /home/user/AFL
    sudo apt-get -y update
    sudo apt-get -y install make
    sudo apt-get -y install gcc
    sudo make install
}

build_the_gnu_coreutils_program()
{
   cd /home/user
   sudo apt-get install -y wget
   wget http://panda.moyix.net/~moyix/lava_corpus.tar.xz
   tar -xvf /home/user/lava_corpus.tar.xz
   cd /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe
   sudo apt-get install -y libacl1-dev
   sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
   echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
   sed -i '1s/^/#include <sys\/sysmacros.h>\n/' lib/mountlist.c
   CC=/usr/local/bin/afl-gcc CXX=/usr/local/bin/afl-g++ /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe/configure --prefix=`pwd`/lava-install LIBS="-lacl"
   make clean all -j4
   make install
}

indicate_that_the_AFL_build_of_the_gnu_coreutils_program_includes_a_vulnerability()
{
   /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe/lava-install/bin/$gnu_coreutils_program -d /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/inputs/utmp-fuzzed-1.b64
}

generate_the_output_of_the_afl-fuzz_command_with_the_gnu_coreutils_program()
{
   cd /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/
   mkdir /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/outputs
   /usr/local/bin/afl-fuzz -i /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/fuzzer_input/ -o /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/outputs/ -- /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe/lava-install/bin/$gnu_coreutils_program -d
}

install_the_dependencies_to_create_the_AFL_coverage_of_the_gnu_coreutils_program()
{
   cd /home/user
   wget http://ftp.gnu.org/gnu/m4/m4-1.4.13.tar.gz
   tar -xvf /home/user/m4-1.4.13.tar.gz
   cd /home/user/m4-1.4.13
   /home/user/m4-1.4.13/configure
   sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
   echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
   sudo make install

   cd /home/user
   wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
   tar -xvf /home/user/autoconf-2.69.tar.gz
   cd /home/user/autoconf-2.69
   /home/user/autoconf-2.69/configure
   make
   sudo make install

   cd /home/user
   wget https://mirror2.evolution-host.com/gnu/automake/automake-1.15.tar.gz
   tar -xvf /home/user/automake-1.15.tar.gz
   cd /home/user/automake-1.15
   /home/user/automake-1.15/configure
   make
   sudo make install

   sudo apt-get install -y gperf

   cd /home/user/
   wget http://ftp.gnu.org/gnu/texinfo/texinfo-6.8.tar.gz
   tar -xvf /home/user/texinfo-6.8.tar.gz
   cd /home/user/texinfo-6.8
   /home/user/texinfo-6.8/configure
   make
   sudo make install

   sudo apt-get install -y makeinfo
   sudo apt-get install -y python2
   sudo apt-get install -y lcov
}

create_the_AFL_coverage_of_the_gnu_coreutils_program()
{
   cd /home/user
   git clone https://github.com/mrash/afl-cov.git
   cd /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/
   cp -r /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe/ /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov
   cd /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov
   make clean distclean
   CFLAGS="-fprofile-arcs -ftest-coverage" /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov/configure --prefix=`pwd`/lava-install  LIBS="-lacl"
   make
   make install
}

generate_the_output_of_the_afl-cov_command_that_is_run_with_the_gnu_coreutils_program()
{
   cd /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov/lava-install/bin
   /home/user/afl-cov/afl-cov -d /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/outputs/ --coverage-cmd "/bin/cat AFL_FILE | /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov/lava-install/bin/$gnu_coreutils_program -d" --code-dir /home/user/lava_corpus/LAVA-M/$gnu_coreutils_program/coreutils-8.24-lava-safe-gcov/src
}

INPUT="$@"
initialize_the_gnu_coreutils_program $INPUT
gnu_coreutils_programs=( "base64" "md5sum" "uniq" "who" )
if [[ -z "$gnu_coreutils_program" || ! " ${gnu_coreutils_programs[@]} " =~ " $gnu_coreutils_program " ]]
then
    echo "The gnu coreutils program could be absent. Provide the gnu coreutils program that could be base64, md5sum, uniq and who."
    exit
fi

build_afl
build_the_gnu_coreutils_program
indicate_that_the_AFL_build_of_the_gnu_coreutils_program_includes_a_vulnerability
generate_the_output_of_the_afl-fuzz_command_with_the_gnu_coreutils_program
install_the_dependencies_to_create_the_AFL_coverage_of_the_gnu_coreutils_program
create_the_AFL_coverage_of_the_gnu_coreutils_program
generate_the_output_of_the_afl-cov_command_that_is_run_with_the_gnu_coreutils_program
