#!/bin/bash

git rev-parse --short HEAD > version.txt
rm -r target/*
make
ls target > latest.txt
mv latest.txt target/

