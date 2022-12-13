# 5bloc-dapp

## Setup dev environment

#### Installations:
 - Install git: [Official Doc](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
 - Install NVM (Gestionnaire Node + NPM):
    - [Documentation Windows](https://github.com/coreybutler/nvm-windows/releases)
    - Linux / Mac : `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash`
 - Install Node JS + NPM:
    - Dans un cmd/bash/pwsh `nvm install 16`
    - Dans un cmd/bash/pwsh `nvm use 16.18.1`
 - Install Truffle (Ethereum dev/test suite):
    - Dans un cmd/bash/pwsh `npm install -g truffle`
 - Install Ganache (Local Blockchain):
    - [Documentation Officielle](https://trufflesuite.com/ganache/)
 - Extensions VSCode:
    - [Remix](https://marketplace.visualstudio.com/items?itemName=RemixProject.ethereum-remix)
    - [Truffle](https://marketplace.visualstudio.com/items?itemName=trufflesuite-csi.truffle-vscode)

#### Configurations

##### Ganache:
 - Rendre la blockchain dispo sur toutes les cartes réseau:  
    Settings > Server > All Interfaces
 - Restart Ganache

##### Metamask:
 - Settings:
    - Network : Local
    - http://localhost:7545
 - Add account:
    - Click on key icon on a Ganache account, copy
    - Account > Import
    - Paste private key

---

## Deploy

 - Put your metamask on Goerli test network
 - Copy/Paste your contract source code to [Remix IDE](https://remix.ethereum.org)
 - Compile your contract
 - On "Deploy & Run Transactions" tab:
    - Environment: "Injected Provider - Metamask"
    - Account: Account you want to deploy your contract with
    - Contract: The one you just compiled
    - Click on "Deploy"

---

## Access

You can now access your contract with the "At Address" and "Deployed contract tab"  
You can check your contract actions on https://goerli.etherscan.io/address/<contract_address>

