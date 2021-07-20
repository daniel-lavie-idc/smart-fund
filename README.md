# smart-fund
A crowdfunding website backed by Ethereum smart contracts.

* Frontend is implemented using Vue.js
* Backend is implemented using express.js
* MongoDB is used as the database for the backend

## Prerequisites
* A Web browser with metamask installed and configured to https://eth.ap.idc.ac.il/ test net (tested on mozilla).

## Installation
1. `sudo apt update`
2. `sudo apt install docker.io`
3. `sudo apt install docker-compose`

Do the following inside the root folder of this project:

4. `sudo docker-compose up -d`

## Usage
Browse to http://localhost:8081.

From there you can start and create a project. You should provide 3 public keys (accounts keys) that will be eligibile to sign on the witdraw tranasaction. In the current implementation, you must use the creater own account public key as one of the keys, as the witdraw function will sign on the transaction with the caller key, which can only be the creator itself (the other key will be given by a different user).

After that, different accounts can contribute to the project (except from the creator itself), so make sure you switch account to fund the project.

When a project is in the Completed state, i.e. when the goal is met and the time for the project did not expire, an account (that is different from the creator account) can generate a signature by pressing the `Generate signature for withdrawing` button. It can then send it to the creator of the project, which then can paste it in the appropriate text box near the `withdraw` button. If all goes well, the withdraw transaction should be successfull and the funds should be delivered to the creator of the project.

## Important notes:
* The different inputs and buttons can appear depending on the project status and the current account being used.
* There can be some race condition as of asynchornoius code which is not perfectly handled, so please be patient and refresh the page if something goes wrong.
* The projects' data is split between the mongo database (title and description) and the blockchain which stores the important information, including the project id. If for some reason, the database get erased (e.g. the database container restart), then it will go out of sync with the blockchain. There will be alert in the frontend for that.
* Transacting to the idc testnet can take some time, so please be patient.