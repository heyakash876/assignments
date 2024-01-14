// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public rate; // Number of Token B units per Token A
    address public owner;

    event Swap(address indexed user, address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address _tokenA, address _tokenB, uint256 _rate) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        rate = _rate;
        owner = msg.sender;
    }

    function swapTokenAForTokenB(uint256 _amountA) public {
        uint256 amountB = _amountA * rate;
        require(tokenA.transferFrom(msg.sender, address(this), _amountA), "Token A transfer failed");
        require(tokenB.transfer(msg.sender, amountB), "Token B transfer failed");
        emit Swap(msg.sender, address(tokenA), address(tokenB), _amountA, amountB);
    }

    function swapTokenBForTokenA(uint256 _amountB) public {
        uint256 amountA = _amountB / rate;
        require(tokenB.transferFrom(msg.sender, address(this), _amountB), "Token B transfer failed");
        require(tokenA.transfer(msg.sender, amountA), "Token A transfer failed");
        emit Swap(msg.sender, address(tokenB), address(tokenA), _amountB, amountA);
    }

    
}
