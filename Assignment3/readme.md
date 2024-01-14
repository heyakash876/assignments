# ERC-20 Token Swap Smart Contract

## Overview
This smart contract enables users to swap between two ERC-20 tokens (Token A and Token B) at a predefined exchange rate. It is designed to be simple, secure, and efficient, providing a straightforward interface for token swapping.

## Features
- **Token Swapping**: Users can swap Token A for Token B and vice versa.
- **Fixed Exchange Rate**: The exchange rate between Token A and Token B is set and immutable.
- **Checks and Balances**: The contract includes checks to ensure swaps adhere to the fixed exchange rate.
- **Event Logging**: Swap events are emitted to log the details of each token swap.

## Functions
- `swapTokenAForTokenB(uint256 _amountA)`: Swaps a specified amount of Token A for Token B.
- `swapTokenBForTokenA(uint256 _amountB)`: Swaps a specified amount of Token B for Token A.

## Requirements
- Solidity ^0.8.0 or higher
- ERC-20 compatible tokens for Token A and Token B

## Setup and Deployment
1. Install dependencies: `npm install @openzeppelin/contracts`

## Testing
Ensure to write and run tests to verify the contract's functionality before deploying:
- Use Foundry: `forge test`

## Security Considerations
Reentrancy Protection: To prevent reentrancy attacks, where a malicious contract could call back into the swap functions to drain funds, reentrancy guards such as the Checks-Effects-Interactions pattern were considered.

Integer Overflow and Underflow: Safe math operations were used to prevent integer overflow and underflow, which could otherwise be exploited to manipulate token balances or swap rates.

ERC-20 Token Standards Compliance: The contract interacts with ERC-20 tokens, so it’s crucial to ensure that the tokens adhere to the standard to prevent unexpected behavior during transfers.

Approval Checks: The contract checks that the user has approved sufficient token allowance before initiating a swap to ensure that the contract can transfer the tokens on behalf of the user.

Rate Fixation: The exchange rate is fixed and immutable to prevent unauthorized changes that could affect the fairness of the swap.

Liquidity Checks: Before allowing a swap, the contract verifies that it has enough of the outgoing token to fulfill the swap, preventing incomplete transactions.

Event Logging: Events are emitted for each swap to provide transparency and an audit trail that can be used to verify the correctness of the swapping process.

Access Control: Functions that could potentially change the state or configuration of the contract are restricted to the owner or authorized accounts.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
