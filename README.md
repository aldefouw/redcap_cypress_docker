# REDCap Cypress Developer Toolkit

This repository includes scripts to download all the repositories necessary for a developer to begin automated testing with the REDCap Cypress Test Framework: 
- [REDCap Cypress](https://github.com/aldefouw/redcap_cypress)
- [REDCap Docker](https://github.com/aldefouw/redcap_docker)
- REDCap Source - Not a repository. Available via the REDCap Community site with username and password.

### Software Prerequisites:
- Git
- Docker Desktop
- Node.js

### Recommended IDE:
- Visual Studio Code

### Download repositories:

1. Clone this repository to your machine.

```
git clone git@github.com:aldefouw/redcap_cypress_docker.git
```

2. Download Repositories

Execute download_repos.sh to download the repositories.  

This script also configures base settings for Cypress.

```
./download_repos.sh
```

3. Download REDCap

Execute download_redcap.sh to download specific version of REDCap you need.  Follow onscreen prompts which require credentials for REDCap Community site.

```
./download_redcap.sh
```   

### Start REDCap Test Environment:

Start your REDCap Docker containers (PHP/Apache, MySQL, Mailhog).  

```
cd redcap_docker
docker compose up
```
    
### Configure & Start Cypress:

1. Install Cypress & dependencies for REDCap Cypress Test Framework (RCTF).

```
cd redcap_cypress
npm install
```

2. Open Cypress.

```
npx cypress open
```

### Contribute to Feature Tests:

1. Create your own fork of redcap_rsvc that is based upon https://github.com/aldefouw/redcap_rsvc

2. Configure the cloned redcap_rsvc repository as needed to match your own Fork.

```
cd redcap_cypress/redcap_rsvc
git remote rename origin upstream
git remote add origin <your_fork_url_here>
```

This is so you can store the features on your fork until you issue a merge request to aldefouw/redcap_rsvc.

### Update Repositories:

Run `./update_repos.sh` from this repository.


## Additional Information

### Rebuild Docker containers

If changes are made to the Docker images, you will need to rebuild your containers before spooling them up.

```
docker compose build
```

### Configure Cypress REDCap Version

If you want to test against a new version of REDCap that you've downloaded, first [Download REDCap](#download-repositories).

Then change the following variable in `redcap_cypress/cypress.env.json` to the specific version of REDCap you want to test:

```
    "redcap_version": "13.1.37"
```

### SSH Key needed

You will need to place your public key on GitHub for this process to work correctly.

To generate a key on your local machine, most of time the command is:
```
ssh-keygen
```

Generating a key is beyond the scope of what this documentation can cover, but please consult GitHub's SSH documentation here for more information: 
https://docs.github.com/en/authentication/connecting-to-github-with-ssh
