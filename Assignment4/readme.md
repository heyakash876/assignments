# Multi-Signature Wallet Smart Contract

## Overview
This project provides a Solidity smart contract for a multi-signature wallet that allows multiple owners to collectively manage and control the funds. The wallet requires a predefined number of owners to approve a transaction before it can be executed.

## Key Features
- **Multi-Ownership**: The wallet is controlled by multiple owners, each with their own private key.
- **Transaction Approval**: A specified threshold of owners is required to approve a transaction.
- **Transaction Management**: Owners can submit, approve, and revoke transactions.
- **Security**: Implements access controls and security measures to safeguard wallet operations.

## Functions
- `submitTransaction`: Submits a transaction proposal to the wallet.
- `confirmTransaction`: Allows an owner to confirm a submitted transaction.
- `revokeConfirmation`: Permits an owner to revoke their confirmation of a transaction.
- `executeTransaction`: Executes a confirmed transaction if it meets the required number of confirmations.
- `isConfirmed`: Checks if a transaction has the required confirmations.

## Requirements
- Solidity ^0.8.0 or higher
- Wallet owners must be distinct and non-zero addresses.
- The number of required confirmations must be greater than zero and less than or equal to the number of owners.

## Security Considerations
Access Control: The contract uses modifiers to restrict sensitive functions such as submitting, confirming, and executing transactions to wallet owners only.

Transaction Integrity: Checks are in place to ensure that transactions exist, are not already executed, and have the necessary confirmations before execution.

Confirmation Management: Owners can confirm or revoke their confirmations for transactions, but they cannot confirm a transaction more than once.

Execution Rules: A transaction can only be executed if it has reached the required threshold of confirmations set during the wallet’s creation.

Reentrancy Guard: To prevent reentrancy attacks, state changes are made before external calls during transaction execution.

Constructor Validations: The constructor of the wallet includes validations to ensure that owners are unique, non-zero addresses, and that the required number of confirmations is within a valid range.

Fallback Function: The contract includes a fallback function to receive Ether and emit a deposit event, without allowing arbitrary data execution..

## License
This project is licensed under the MIT License - see the LICENSE file for details.
