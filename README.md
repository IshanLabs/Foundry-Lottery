# Foundry Lottery

A decentralized lottery smart contract built with Solidity and Foundry that uses Chainlink VRF for randomness and Chainlink Automation for automated winner selection.

## Overview

This project implements a lottery system where users can:

* Enter a lottery by paying an entrance fee
* Automatically trigger winner selection after a time interval
* Select winners using verifiable randomness
* Reset and reopen the lottery for the next round

The project was built primarily for learning smart contract development, testing, deployment workflows, and decentralized application architecture.

---

## Features

* Solidity smart contract implementation
* Chainlink VRF integration for random winner selection
* Chainlink Automation integration for automated execution
* Custom errors for gas optimization
* Foundry testing environment
* Local deployment using Anvil
* Deployment scripts using Foundry scripts
* Mock VRF implementation for local testing

---

## Tech Stack

* Solidity
* Foundry
* Anvil
* Chainlink VRF v2
* Chainlink Automation
* Git & GitHub

---

## Project Structure

src/

├── Lottery.sol

script/

├── DeployLottery.s.sol

├── HelperConfig.s.sol

test/

├── TestLottery.t.sol

---

## Installation

Clone repository:

```bash
git clone <repository-url>
cd Foundry-Lottery
```

Install dependencies:

```bash
forge install
```

Build:

```bash
forge build
```

---

## Run Tests

```bash
forge test -vv
```

---

## Run Local Blockchain

Start Anvil:

```bash
anvil
```

Deploy contract:

```bash
forge script script/DeployLottery.s.sol \
--rpc-url http://127.0.0.1:8545 \
--private-key <PRIVATE_KEY> \
--broadcast
```

---

## Local Interaction Example

Enter Lottery:

```bash
cast send <CONTRACT_ADDRESS> \
"enterLottery()" \
--value 10000000000000000 \
--private-key <PRIVATE_KEY> \
--rpc-url http://127.0.0.1:8545
```

Check Player Count:

```bash
cast call <CONTRACT_ADDRESS> \
"getPlayerNumbers()(uint256)" \
--rpc-url http://127.0.0.1:8545
```

---

## Learning Goals

This project was created to learn:

* Smart contract architecture
* Solidity best practices
* Testing with Foundry
* Chainlink integrations
* Deployment workflows
* Local blockchain development
* Web3 development fundamentals

---

## Future Improvements

* Frontend integration
* Wallet connection support
* Better UI/UX
* Deployment to public testnets
* Improved testing coverage
* Event indexing and analytics

---

## Contributions & Acknowledgements

Project implementation, development, testing, debugging, and deployment were done by the repository owner.

Development was assisted by ChatGPT for:

* Debugging guidance
* Architecture discussions
* Testing support
* Deployment workflows
* Explanations and learning assistance

This project is intended as a learning project and portfolio project.
