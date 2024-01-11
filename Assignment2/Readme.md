# Voting System Smart Contract

## Overview
This project implements a decentralized voting system using a Solidity smart contract. The contract allows users to register to vote, the owner to add candidates, and registered voters to cast their votes for specific candidates. The voting process is transparent, and the results are publicly accessible.

## Features
- **User Registration**: Users can register to vote through the contract.
- **Candidate Management**: The owner can add candidates to the ballot.
- **Voting**: Registered voters can cast their votes for their preferred candidate.
- **Transparency**: The voting process and results are transparent and publicly accessible.
- **One Vote Per Voter**: Ensures that each voter can only vote once.
- **Events**: Logs important actions such as voter registration, candidate addition, and votes cast.

## Functions
- `registerVoter(address _voter)`: Registers a voter.
- `addCandidate(string memory _name)`: Adds a new candidate.
- `startVoting()`: Begins the voting process.
- `vote(uint _candidateIndex)`: Casts a vote for a candidate.
- `endVoting()`: Ends the voting process.
- `getResults()`: Retrieves the election results.
- `getCandidates()`: Retrieves the list of candidates.

## Requirements
- Solidity ^0.8.0
- OpenZeppelin Contracts (for secure contract standards)

## Setup and Deployment
 build the contract: `forge build`


## Testing

- Run tests using Foundry: `forge test`

## Design choices
The design choices made for the Voting System smart contract were guided by the need for a secure, transparent, and user-friendly voting process. Here are some key considerations:

Solidity Version: The contract is written in Solidity ^0.8.0 to leverage the latest language features and security improvements.
Data Structures: Structs are used to represent voters and candidates, allowing for efficient storage and retrieval of their details.
Access Control: The onlyOwner modifier ensures that only the contract owner can perform certain administrative actions, such as adding candidates or starting the voting process.
Transparency: All key actions emit events, providing a transparent and verifiable record of the voting process on the blockchain.
Security: Checks are in place to prevent common vulnerabilities, such as reentrancy attacks or overflows. Voters can only vote once, and their status is tracked within the contract.
Gas Efficiency: Fixed-size bytes32 types were initially used for candidate names to optimize for gas costs. However, this was later changed to accept string inputs for ease of use, with names being hashed to bytes32 for storage.
User Experience: The contract includes functions to view candidates and results, making it easy for users to interact with the contract and verify the election outcome.

## Security considerations
Access Control: The contract uses an onlyOwner modifier to restrict sensitive functions such as adding candidates or starting the voting process to the contract owner, preventing unauthorized manipulation.

Input Validation: All user inputs, such as voter registration and candidate names, are validated to prevent invalid data from being processed.

One Vote Per Voter: The contract tracks whether a voter has already voted to enforce the rule that each registered voter can only vote once, preventing double voting.

Transparent Process: By emitting events for key actions and making results publicly accessible, the contract ensures transparency and allows for independent verification of the voting process.

Reentrancy Protection: Although not explicitly mentioned in the provided contract, reentrancy guards should be implemented to prevent attacks that could occur if external calls are made to untrusted contracts.

Gas Limitations: Careful consideration of gas costs and limitations ensures that contract functions do not run out of gas, which could disrupt the voting process.
## License
This project is licensed under the MIT License - see the LICENSE file for details.
