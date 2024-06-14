#!/usr/bin/env bash

## What version of REDCap
read -p "Enter REDCap version you want to install: " redcap_version


# Get existing REDCap version from redcap_cypress/cypress.env.json
CYPRESS_ENV_FILE="./redcap_cypress/cypress.env.json"

# Get the version line from the file
CYPRESS_REDCAP_VERSION_LINE=$(grep -i "redcap_version" $CYPRESS_ENV_FILE)

# Get the version number from the line
CURRENT_VERSION=$(echo $CYPRESS_REDCAP_VERSION_LINE | sed -n 's/.*"redcap_version": "\([^"]*\)".*/\1/p')

# Prompt the user for confirmation before replacing the version
REPLACE_VERSION="N"
read -p "Configured REDCap version in cypress.env.json is ${CURRENT_VERSION} do you want to replace with ${redcap_version}? (y/${REPLACE_VERSION}):" REPLACE_VERSION

# Replace the version if the user confirms
if [ "${REPLACE_VERSION}" == "y" ]; then
    error=$(find "${CYPRESS_ENV_FILE}" -type f -exec sed -i -e "s/$CURRENT_VERSION/${redcap_version}/g" {} \;) || echo "FAILED:\n$error"
fi

# Zip file
zip_file="./redcap${redcap_version}.zip"

# Check if the file exists
if [ -e "$zip_file" ]; then
    echo "Zip file for REDCap ${redcap_version} already exists.  We'll use this to zip to install."
else
    echo "To download REDCap, you must login to REDCap Community site (https://redcap.vanderbilt.edu/community/) to verify you have valid license."
    echo "This script handles that login process for you."
    echo "Please enter your credentials for the REDCap Community site in the prompts that follow."

    # Prompt the user for username
    read -p "Enter your username: " username

    # Prompt the user for password (without echoing characters)
    read -sp "Enter your password: " password
    echo

    # URL of the file to download
    url="https://redcap.vanderbilt.edu/plugins/redcap_consortium/versions.php"

    # Perform the curl request with username and password
    curl -o ${zip_file} -d "username=${username}&password=${password}&version=${redcap_version}&install=1" -X POST ${url}

    if [ $? -eq 0 ]; then
      echo "Zip file downloaded successfully."
    fi
fi

#Target Directory
target_directory=./tmp

# Check if the curl request (or zip exists)
if [ -e "$zip_file" ]; then

    # Unzip the file to the target directory
    unzip -q "${zip_file}" -d ${target_directory}

    if [ $? -eq 0 ]; then

        echo "Files for REDCap v${redcap_version} downloaded and unzipped successfully in ${target_directory}."

        redcap_source_dir="./redcap_source"

        #If we are upgrading
        if [ -e "$redcap_source_dir" ]; then

            #We are just copying the specific folder we need - not the whole install!
            mv ${target_directory}/redcap/redcap_v${redcap_version} redcap_source/redcap_v${redcap_version}
            if [ $? -eq 0 ]; then
              echo "REDCap full install files moved to ./redcap_source directory."
            fi

        #If this is a first time install
        else

          #This copies the entire install
          mv ${target_directory}/redcap redcap_source
          if [ $? -eq 0 ]; then
            echo "REDCap full install files moved to ./redcap_source directory."
          fi

          #This database.php is specifically configured for this Docker container DB setup
          cp ./config/database.php ./redcap_source/database.php
          if [ $? -eq 0 ]; then
            echo "Database connection successfully configured."
          fi
        fi

        #Let's clean up the temp files
        rm -r tmp
        if [ $? -eq 0 ]; then
          echo "Cleaned up temporary files."
        fi

    else
        echo "Failed to unzip the file."
    fi

else
    echo "Failed to download REDCap. Please check your credentials and try again."
fi