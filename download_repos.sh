#!/usr/bin/env bash

git submodule init

# Define submodule URLs and paths
declare -a submodule_urls=("git@github.com:aldefouw/redcap_cypress.git" "git@github.com:aldefouw/redcap_docker.git")
declare -a submodule_paths=("redcap_cypress" "redcap_docker")

# Clone submodule repositories and add them as submodules
for ((i=0; i<${#submodule_urls[@]}; ++i)); do
    submodule_url=${submodule_urls[$i]}
    submodule_path=${submodule_paths[$i]}

    # Clone submodule repository
    git clone $submodule_url $submodule_path

    # Add submodule to main repository
    git submodule add $submodule_url $submodule_path
done

#Move Base Configurations for Cypress
mv ./config/cypress.config.js ./redcap_cypress/cypress.config.js
mv ./config/cypress.env.json ./redcap_cypress/cypress.env.json

#Install the REDCap RSVC repository so automated feature tests can run
cd redcap_cypress || exit
git clone git@github.com:aldefouw/redcap_rsvc.git
git submodule add git@github.com:aldefouw/redcap_rsvc.git redcap_rsvc