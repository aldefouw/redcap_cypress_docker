#!/bin/sh

set -e

cd redcap_docker
docker compose up -d

cd ..

cd redcap_cypress
npm install --no-fund
npm run redcap_rsvc:validate_features

# Ideally we'd call "npm run redcap_rsvc:move_files" here instead of the following lines,
# but we can't do that currently because "redcap_rsvc:move_files" contains
# a "move-cli node_modules/redcap_rsvc redcap_rsvc" command which only makes sense in
# a cloud environment in its current form (would cause problems for local development).
rm -rf cypress/fixtures/cdisc_files cypress/fixtures/dictionaries cypress/fixtures/import_files
cp -a redcap_rsvc/Files/* cypress/fixtures/

if [[ "$OSTYPE" == "msys" ]]; then
    # Work around this issue in Git Bash: https://github.com/cypress-io/cypress/issues/789
    SHELL=''
fi

npx cypress open