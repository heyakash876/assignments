const TokenSale = artifacts.require('TokenSale');
const Token = artifacts.require('Token');

contract('TokenSale', function ([deployer, investor1, investor2]) {
    let tokenSale;
    let token;
    const tokensAvailable = 1000000;

    before(async function() {
        token = await Token.new('Project Token', 'PTK', tokensAvailable, { from: deployer });
        tokenSale = await TokenSale.new(token.address, { from: deployer });
        await token.transfer(tokenSale.address, tokensAvailable, { from: deployer });
    });

    it('initializes the contract with the correct values', async function() {
        const address = await tokenSale.address;
        assert.notEqual(address, 0x0, 'has contract address');
        const tokenContractAddress = await tokenSale.tokenContract();
        assert.notEqual(tokenContractAddress, 0x0, 'has token contract address');
    });

    it('facilitates token buying', async function() {
        const numberOfTokens = 10;
        const value = numberOfTokens;
        const receipt = await tokenSale.buyTokens(numberOfTokens, { from: investor1, value: value });
        const amount = await tokenSale.tokensSold();
        assert.equal(amount.toNumber(), numberOfTokens, 'increments the number of tokens sold');
        const event = receipt.logs[0];
        assert.equal(event.args._buyer, investor1, 'logs the account that purchased the tokens');
        assert.equal(event.args._amount.toNumber(), numberOfTokens, 'logs the number of tokens purchased');
        const balance = await token.balanceOf(investor1);
        assert.equal(balance.toNumber(), numberOfTokens);
    });

    it('ends token sale', async function() {
        await tokenSale.endSale({ from: deployer });
        const balance = await token.balanceOf(deployer);
        assert.equal(balance.toNumber(), tokensAvailable - 10, 'returns all unsold tokens to admin');
    });
});
