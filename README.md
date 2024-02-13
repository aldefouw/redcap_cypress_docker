# redcap_cypress_docker

This repository includes scripts to perform a standard download of all of the repositories necessary for automated testing with the REDCap Cypress Test Framework: 
- REDCap Cypress
- REDCap Docker
- REDCap Source *

To download the repositories:

1. Clone this repo to your machine.

2. Run `./download_repos.sh` to download the responsitories.  This script also configures base settings for Cypress.

3. Start your REDCap Docker containers.  

`cd redcap_docker`

`docker compose up`

4. Install Cypress & dependencies

`cd redcap_cypress`

`npm install`

5. Open Cypress 

`npx cypress open`

6. Configure the Feature Test Remote as needed to match your own Fork

```
cd redcap_cypress/redcap_rsvc
git remote rename origin upstream
git remote add origin <your_fork_url_here>
```

This is so you can store the features on your fork until you issue a merge request to aldefouw/redcap_rsvc.

*REDCap Source is only available after you are authorized to access it and you have been cleared to have a valid license of REDCap.  
