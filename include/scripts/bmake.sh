#!/bin/bash
ERR="\e[31m"
WARN="\e[33m"
EC="\e[0m"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "This script was made to see if a cmake project builds"
    echo "It essentially creates a build directory, runs cmake then make on a project"
    echo "Any flags ran with the bmake command will be utilizes as part of the cmake command"
    echo "Usage: $0 -DSOME_FLAG=1"
    echo "Where SOME_FLAG=1 is passed into the cmake command"
    echo "You dont need any flags for cmake, but if you did that is how you would use it"
    echo "If you are not currently in a cmake project / if no CMakeLists.txt if found, an error will appear"
    echo ""
    echo "-h, --help    Display this help message"
    exit 0
fi

[ ! -f ./CMakeLists.txt ] && echo "${ERR}ERROR: CMakeLists.txt does not exist" && exit 1
[ -d ./build ] && echo "${WARN}WARNING: Deleting existing build directory" && rm -rf ./build
mkdir ./build
cd ./build
cmake ../ $@
make 
cd ../
rm -rf ./build
