#!/bin/bash

set -e

# Check if user has root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

apt update

# check for curl and install if not present
if ! [ -x "$(command -v curl)" ]; then
    echo "Installing curl"
    apt install curl -y
fi

# check for openssl and install if not present
if ! [ -x "$(command -v openssl)" ]; then
    echo "Installing openssl"
    apt install openssl -y
fi

# Creating the directory where the script will be stored
mkdir -p /etc/GitCatcher

# Copy the script to the /etc directory
cp -r . /etc/GitCatcher/

# Specify the Git repository URL
# read -p "Enter the git repo url that you want to sync: " git_url

# git_url="https://github.com/krt1k/gitcatcher_test.git"

ln -s /etc/GitCatcher/dist/run-py /usr/bin/gitcatch
chmod +x /usr/bin/gitcatch

current_minute=$(date +"%M")

# check for $1 for rentlyEmail if empty prompt input from the user
if [ -z "$1" ]; then
    read -p "Enter your rently email address: " rentlyEmail
else
    rentlyEmail=$1
    echo "New email address: $rentlyEmail"
fi

echo "export rentlyEmail=\"${rentlyEmail}\"" >> /etc/environment
source /etc/environment

# create a cronjob that runs the script every three hour
echo "$current_minute */3 * * * root /usr/bin/gitcatch" >> /etc/crontab 

# script v1.13
