# REDCap Cypress Developer Toolkit

This repository includes scripts to perform a standard download of all of the repositories necessary for automated testing with the REDCap Cypress Test Framework: 
- REDCap Cypress
- REDCap Docker
- REDCap Source *

*REDCap Source is only available to those with access via the REDCap Community site due to licensing requirements.

##SSH Key needed

You will need to configure an SSH key on Github for this process to work correctly.  

For more information, please consult GitHub's SSH documentation here: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

### Software Prerequisites:
- Visual Studio Code
- Git
- Docker Desktop
- Node.js

### To DOWNLOAD the repositories:

1. Clone this repository to your machine.

2. Run `./download_repos.sh` to download the repositories.  This script also configures base settings for Cypress.

3. Run `./download_redcap.sh` to download specific version of REDCap you need.  Follow onscreen prompts.   

4. Start your REDCap Docker containers (PHP/Apache, MySQL, Mailhog).  

    ```
    cd redcap_docker
    docker compose up
    ```

5. Install Cypress & dependencies for REDCap Cypress Test Framework (RCTF).

    ```
    cd redcap_cypress
    npm install
    ```

6. Open Cypress.

   ```
   npx cypress open
   ```

7. Configure the redcap_rsvc (Feature Tests) repository as needed to match your own Fork.

    ```
    cd redcap_cypress/redcap_rsvc
    git remote rename origin upstream
    git remote add origin <your_fork_url_here>
    ```

This is so you can store the features on your fork until you issue a merge request to aldefouw/redcap_rsvc.

### To UPDATE the repositories:

Run `./update_repos.sh` from this repository.


### To rebuild Docker containers

If changes are made to the Docker images, you will need to rebuild your containers before spooling them up.

```
docker compose build

```
