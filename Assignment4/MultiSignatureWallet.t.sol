// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/MultiSignatureWallet.sol";

contract MultiSignatureWalletTest is Test {
    MultiSignatureWallet wallet;
    address[] owners;
    uint required;

    function setUp() public {
        // Set up the owners and required confirmations for the multi-sig wallet
        owners = new address;
        owners[0] = address(0x1);
        owners[1] = address(0x2);
        owners[2] = address(0x3);
        required = 2;

        // Deploy the multi-sig wallet with the owners and required confirmations
        wallet = new MultiSignatureWallet(owners, required);
    }

    function testDeposit() public {
        // Test depositing funds to the wallet
        payable(address(wallet)).transfer(1 ether);
        assertEq(address(wallet).balance, 1 ether, "Balance should be 1 ether after deposit");
    }

    function testSubmitTransaction() public {
        // Test submitting a transaction
        address destination = address(0x4);
        uint value = 0.5 ether;
        bytes memory data = "";
        wallet.submitTransaction(destination, value, data);

        // Check that the transaction is in the transactions array
        (address txnDestination, uint txnValue, bytes memory txnData, bool executed) = wallet.transactions(0);
        assertEq(txnDestination, destination, "Transaction destination should match");
        assertEq(txnValue, value, "Transaction value should match");
        assertEq(executed, false, "Transaction should not be executed yet");
    }

    function testConfirmTransaction() public {
        // Test confirming a transaction
        wallet.submitTransaction(address(0x4), 0.5 ether, "");
        vm.prank(owners[0]);
        wallet.confirmTransaction(0);

        // Check that the transaction is confirmed by the first owner
        bool isConfirmed = wallet.confirmations(0, owners[0]);
        assertTrue(isConfirmed, "Transaction should be confirmed by the first owner");
    }

    function testExecuteTransaction() public {
        // Test executing a transaction
        wallet.submitTransaction(address(0x4), 0.5 ether, "");
        vm.prank(owners[0]);
        wallet.confirmTransaction(0);
        vm.prank(owners[1]);
        wallet.confirmTransaction(0);
        vm.prank(owners[0]);
        wallet.executeTransaction(0);

        // Check that the transaction is executed
        (, , , bool executed) = wallet.transactions(0);
        assertTrue(executed, "Transaction should be executed");
    }
}
