#!/bin/bash
#to be executed from the root project directory

#quitting on error
set -e

#marking uncommitted changes is based on:
#http://stackoverflow.com/questions/3878624/how-do-i-programmatically-determine-if-there-are-uncommited-changes/9393642#9393642
#checking status before creating version.txt file in order to ignore it (it should be added to git:ignore anyway)
modified=`git status -s`
git rev-parse --short HEAD | tr -d '\n' > shiny/version.txt
if [[ -n $modified ]]; then
    echo ' [locally modified]' >> shiny/version.txt
fi

rm -rf target/*
make clean build
echo `ls target` > target/latest.txt
rm shiny/version.txt
