#!/bin/sh

set -e

cd redcap_docker
docker compose up -d

cd ..

cd redcap_cypress
npm install
npm run redcap_rsvc:validate_features
rm -rf cypress/fixtures/cdisc_files cypress/fixtures/dictionaries cypress/fixtures/import_files
cp -a redcap_rsvc/Files/* cypress/fixtures/

if [[ "$OSTYPE" == "msys" ]]; then
    # Work around this issue in Git Bash: https://github.com/cypress-io/cypress/issues/789
    SHELL=''
fi

npx cypress open