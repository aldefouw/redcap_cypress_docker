#!/usr/bin/env bash

check_zip_integrity() {
    local file=$1
    unzip -t "$file" &> /dev/null
    return $? # Return the exit status of the unzip command
}

attempt_unzip_redcap() {
    local zip_file=$1

    if check_zip_integrity "${zip_file}"; then

        #Target Directory
        target_directory=./tmp
        mkdir -p $target_directory

        # Define the destination directory
        destination_directory="redcap_source/redcap_v${redcap_version}"

        # Check if the curl request (or zip exists)
        if [ -e "$zip_file" ]; then

            # Unzip the file to the target directory
            unzip -q "${zip_file}" -d ${target_directory}

            if [ $? -eq 0 ]; then

                echo "Files for REDCap v${redcap_version} downloaded and unzipped successfully in ${target_directory}."

                redcap_source_dir="./redcap_source"

                #If we are upgrading
                if [ -e "$redcap_source_dir" ]; then

                  #Empty destination (what we want)
                  if [ -z "$(ls -A "$destination_directory")" ]; then

                      #We are just copying the specific folder we need - not the whole install!
                      mv ${target_directory}/redcap/redcap_v${redcap_version} ${destination_directory}
                      if [ $? -eq 0 ]; then
                        echo "REDCap v${redcap_version} files moved to ${destination_directory} directory."
                      fi

                  #Destination already has something ... we cannot move the files
                  else
                      echo "Destination directory ${destination_directory} is NOT empty.  Cannot move the REDCap v${redcap_version} files there."
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

                echo "Configuring Cypress to use REDCap v${redcap_version}"
                sed -i '/  "redcap_version": ".*",/c\  "redcap_version": "'${redcap_version}'",' redcap_cypress/cypress.env.json

            else
                echo "Failed to unzip the file."
            fi

        else
            echo "Failed to download REDCap. Please check your credentials and try again."
        fi

    else
        echo "No valid REDCap zip found. Please verify your REDCap Community credentials and try again."

        #Delete the invalid file since it would prevent a new download in the future
        rm -f ${zip_file}

        exit 1
    fi
}

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
    attempt_unzip_redcap "${zip_file}"
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
    curl -v -o ${zip_file} --data username=$username --data-urlencode password=$password --data version=$redcap_version --data install=1 -X POST ${url}

    if [ $? -eq 0 ]; then
        attempt_unzip_redcap "${zip_file}"
    fi
fi