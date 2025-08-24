#!/bin/sh
ERR="\e[31m"
WARN="\e[33m"
EC="\e[0m"
[ ! -f ./CMakeLists.txt ] && echo "${ERR}ERROR: CMakeLists.txt does not exist" && exit 1
[ -d ./build ] && echo "${WARN}WARNING: Deleting existing build directory" && rm -rf ./build
mkdir ./build
cd ./build
cmake ../ $@
make 
cd ../
rm -rf ./build
