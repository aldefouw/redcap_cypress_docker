#!/bin/sh

cd redcap_docker
docker compose up -d

cd ..

cd redcap_cypress
npm install
rm -r cypress/fixtures/*
cp -a redcap_rsvc/Files/* cypress/fixtures/

if [[ "$OSTYPE" == "msys" ]]; then
    # Work around this issue in Git Bash: https://github.com/cypress-io/cypress/issues/789
    SHELL=''
fi

npx cypress open