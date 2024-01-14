// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/TokenSwap.sol";
import "../contracts/TokenA.sol";
import "../contracts/TokenB.sol";

contract TokenSwapTest is Test {
    TokenSwap tokenSwap;
    TokenA tokenA;
    TokenB tokenB;
    address user = address(0x1);
    uint256 rate = 100; // Example rate: 1 Token A = 100 Token B

    function setUp() public {
        tokenA = new TokenA("Token A", "TKNA");
        tokenB = new TokenB("Token B", "TKNB");
        tokenSwap = new TokenSwap(address(tokenA), address(tokenB), rate);

        tokenA.mint(address(tokenSwap), 1000 ether); // Mint Token A to TokenSwap contract
        tokenB.mint(address(tokenSwap), 100000 ether); // Mint Token B to TokenSwap contract

        tokenA.mint(user, 10 ether); // Mint Token A to user for testing
        tokenB.mint(user, 1000 ether); // Mint Token B to user for testing

        tokenA.approve(address(tokenSwap), 10 ether); // User approves TokenSwap to spend Token A
        tokenB.approve(address(tokenSwap), 1000 ether); // User approves TokenSwap to spend Token B
    }

    function testSwapTokenAForTokenB() public {
        uint256 userTokenBBalanceBefore = tokenB.balanceOf(user);
        uint256 amountA = 1 ether;

        vm.startPrank(user);
        tokenSwap.swapTokenAForTokenB(amountA);
        vm.stopPrank();

        uint256 userTokenBBalanceAfter = tokenB.balanceOf(user);
        uint256 expectedTokenB = userTokenBBalanceBefore + (amountA * rate);

        assertEq(userTokenBBalanceAfter, expectedTokenB, "User should receive correct amount of Token B");
    }

    function testSwapTokenBForTokenA() public {
        uint256 userTokenABalanceBefore = tokenA.balanceOf(user);
        uint256 amountB = 100 ether;

        vm.startPrank(user);
        tokenSwap.swapTokenBForTokenA(amountB);
        vm.stopPrank();

        uint256 userTokenABalanceAfter = tokenA.balanceOf(user);
        uint256 expectedTokenA = userTokenABalanceBefore + (amountB / rate);

        assertEq(userTokenABalanceAfter, expectedTokenA, "User should receive correct amount of Token A");
    }
}
