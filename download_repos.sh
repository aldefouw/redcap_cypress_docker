#!/usr/bin/env bash

git submodule init

# Define submodule URLs and paths
declare -a submodule_urls=("git@github.com:aldefouw/redcap_cypress.git" "git@github.com:aldefouw/redcap_docker.git" "git@github.com:aldefouw/redcap_source.git")
declare -a submodule_paths=("redcap_cypress" "redcap_docker" "redcap_source")

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
mv cypress.config.js redcap_cypress/cypress.config.js 
mv cypress.env.json redcap_cypress/cypress.env.json

cd redcap_cypress
git clone git@github.com:aldefouw/redcap_rsvc.git
git submodule add git@github.com:aldefouw/redcap_rsvc.git redcap_rsvc