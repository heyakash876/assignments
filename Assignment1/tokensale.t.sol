import "ds-test/test.sol";
import "../TokenSale.sol";

contract TokenSaleTest is DSTest {
    TokenSale tokenSale;

    function setUp() public {
        tokenSale = new TokenSale();
    }

    function testBuyTokens() public {
        // actual values can be added
        uint256 numberOfTokens = 10;
        uint256 value = numberOfTokens;
        tokenSale.buyTokens(numberOfTokens);
        uint256 amount = tokenSale.tokensSold();
        assertEq(amount, numberOfTokens, "Should increment the number of tokens sold");
    }

    function testEndSale() public {
        //actual values can be added
        tokenSale.endSale();
        uint256 balance = tokenSale.balanceOf(msg.sender);
        assertEq(balance, tokensAvailable - 10, "Should return all unsold tokens to admin");
    }
}
