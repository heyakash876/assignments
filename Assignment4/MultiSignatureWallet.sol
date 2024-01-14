// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSignatureWallet {
    event Deposit(address indexed sender, uint amount);
    event Submission(uint indexed transactionId);
    event Confirmation(address indexed owner, uint indexed transactionId);
    event Execution(uint indexed transactionId);
    event ExecutionFailure(uint indexed transactionId);
    event Revocation(address indexed owner, uint indexed transactionId);

    struct Transaction {
        address destination;
        uint value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;
    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public confirmations;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    modifier transactionExists(uint transactionId) {
        require(transactions.length > transactionId, "Transaction does not exist");
        _;
    }

    modifier confirmed(uint transactionId, address owner) {
        require(confirmations[transactionId][owner], "Transaction not confirmed");
        _;
    }

    modifier notExecuted(uint transactionId) {
        require(!transactions[transactionId].executed, "Transaction already executed");
        _;
    }

    modifier notConfirmed(uint transactionId, address owner) {
        require(!confirmations[transactionId][owner], "Transaction already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid number of required confirmations");

        for (uint i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "Invalid owner");
            require(!isOwner[_owners[i]], "Owner not unique");

            isOwner[_owners[i]] = true;
            owners.push(_owners[i]);
        }

        required = _required;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submitTransaction(address destination, uint value, bytes memory data) public onlyOwner {
        uint transactionId = transactions.length;
        transactions.push(Transaction({
            destination: destination,
            value: value,
            data: data,
            executed: false
        }));

        emit Submission(transactionId);
    }

    function confirmTransaction(uint transactionId) public onlyOwner transactionExists(transactionId) notConfirmed(transactionId, msg.sender) {
        confirmations[transactionId][msg.sender] = true;
        emit Confirmation(msg.sender, transactionId);
    }

    function executeTransaction(uint transactionId) public onlyOwner transactionExists(transactionId) confirmed(transactionId, msg.sender) notExecuted(transactionId) {
        if (isConfirmed(transactionId)) {
            Transaction storage txn = transactions[transactionId];
            txn.executed = true;
            (bool success, ) = txn.destination.call{value: txn.value}(txn.data);
            if (success)
                emit Execution(transactionId);
            else {
                emit ExecutionFailure(transactionId);
                txn.executed = false;
            }
        }
    }

    function revokeConfirmation(uint transactionId) public onlyOwner confirmed(transactionId, msg.sender) notExecuted(transactionId) {
        confirmations[transactionId][msg.sender] = false;
        emit Revocation(msg.sender, transactionId);
    }

    function isConfirmed(uint transactionId) public view returns (bool) {
        uint count = 0;
        for (uint i = 0; i < owners.length; i++) {
            if (confirmations[transactionId][owners[i]])
                count += 1;
            if (count == required)
                return true;
        }
        return false;
    }
}
