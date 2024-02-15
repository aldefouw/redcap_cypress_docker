#!/usr/bin/env bash

# Prompt the user for username
read -p "Enter your username: " username

# Prompt the user for password (without echoing characters)
read -sp "Enter your password: " password
echo

# What version of REDCap
read -p "Enter the desired REDCap version: " redcap_version

# URL of the file to download
url="https://redcap.vanderbilt.edu/plugins/redcap_consortium/versions.php"

# Zip file
zip_file="redcap${redcap_version}.zip"

#Target Directory
target_directory=./

# Perform the curl request with username and password
curl -o ${zip_file} -d "username=${username}&password=${password}&version=${redcap_version}&install=1" -X POST ${url}

# Check if the curl request was successful
if [ $? -eq 0 ]; then
    # Unzip the file to the target directory
    unzip -q "${zip_file}" -d ${target_directory}

    if [ $? -eq 0 ]; then
        echo "File downloaded and unzipped successfully in ${target_directory}."

        echo "Files moved to /redcap_source directory"
        mv redcap redcap_source

        cp database.php redcap_source/database.php
        echo "Database connection successfully configured"

    else
        echo "Failed to unzip the file."
    fi

    # Clean up the zip file
    rm "${zip_file}"
else
    echo "Failed to download REDCap. Please check your credentials and try again."
fi