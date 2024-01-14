//SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSale is Ownable {
    ERC20 public token;
    uint256 public presaleRate;
    uint256 public publicSaleRate;
    uint256 public presaleCap;
    uint256 public publicSaleCap;
    uint256 public presaleMinContribution;
    uint256 public presaleMaxContribution;
    uint256 public publicSaleMinContribution;
    uint256 public publicSaleMaxContribution;
    uint256 public presaleRaised;
    uint256 public publicSaleRaised;
    bool public presaleActive;
    bool public publicSaleActive;
    mapping(address => uint256) public contributions;

    event TokensPurchased(address indexed purchaser, uint256 value, uint256 amount);

    constructor(ERC20 _token, uint256 _presaleRate, uint256 _publicSaleRate, uint256 _presaleCap, uint256 _publicSaleCap, uint256 _presaleMinContribution, uint256 _presaleMaxContribution, uint256 _publicSaleMinContribution, uint256 _publicSaleMaxContribution) Ownable(msg.sender) {
        token = _token;
        presaleRate = _presaleRate;
        publicSaleRate = _publicSaleRate;
        presaleCap = _presaleCap;
        publicSaleCap = _publicSaleCap;
        presaleMinContribution = _presaleMinContribution;
        presaleMaxContribution = _presaleMaxContribution;
        publicSaleMinContribution = _publicSaleMinContribution;
        publicSaleMaxContribution = _publicSaleMaxContribution;
    }

    function startPresale() external onlyOwner {
        presaleActive = true;
    }

    function endPresale() external onlyOwner {
        presaleActive = false;
    }

    function startPublicSale() external onlyOwner {
        publicSaleActive = true;
    }

    function endPublicSale() external onlyOwner {
        publicSaleActive = false;
    }

    function buyTokens() external payable {
        require(presaleActive || publicSaleActive, "No active sale");
        uint256 amount;
        if (presaleActive) {
            require(msg.value >= presaleMinContribution && msg.value <= presaleMaxContribution, "Invalid contribution amount");
            require(presaleRaised + msg.value <= presaleCap, "Presale cap reached");
            amount = msg.value * presaleRate;
            presaleRaised += msg.value;
        } else {
            require(msg.value >= publicSaleMinContribution && msg.value <= publicSaleMaxContribution, "Invalid contribution amount");
            require(publicSaleRaised + msg.value <= publicSaleCap, "Public sale cap reached");
            amount = msg.value * publicSaleRate;
            publicSaleRaised += msg.value;
        }
        contributions[msg.sender] += msg.value;
        token.transfer(msg.sender, amount);
        emit TokensPurchased(msg.sender, msg.value, amount);
    }

    function distributeTokens(address _beneficiary, uint256 _amount) external onlyOwner {
        token.transfer(_beneficiary, _amount);
    }

    function claimRefund() external {
        require(!presaleActive && !publicSaleActive, "Sale is active");
        require((presaleRaised < presaleCap && contributions[msg.sender] > 0) || (publicSaleRaised < publicSaleCap && contributions[msg.sender] > 0), "No refund available");
        uint256 refund = contributions[msg.sender];
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(refund);
    }

    function withdrawFunds() external onlyOwner {
        require(address(this).balance > 0, "No funds to withdraw");
        payable(owner()).transfer(address(this).balance);
    }
}
