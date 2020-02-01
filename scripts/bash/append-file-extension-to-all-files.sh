#!/bin/bash

# Appends the '.log' file extension to ALL files in a directory

for f in $(ls /var/log/myapplogs/ --hide="*.log")
do
    mv "$f" "$f.log"
done