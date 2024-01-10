# TOKEN Sale Smart Contract
A token sale smart contract for a new blockchain project. The token sale will be conducted in
two phases: a presale and a public sale. The smart contract is able to handle the following
functionalities:
### Presale:
● Users can contribute Ether to the presale and receive project tokens in return.
● The presale has a maximum cap on the total Ether that can be raised.
● The presale has a minimum and maximum contribution limit per participant.
● Tokens are distributed immediately upon contribution.
### Public Sale:
● After the presale ends, the public sale begins.
● Users can contribute Ether to the public sale and receive project tokens in return.
● The public sale has a maximum cap on the total Ether that can be raised.
● The public sale has a minimum and maximum contribution limit per participant.
● Tokens are distributed immediately upon contribution.
### TOKEN DISTRIBUTION
● The smart contract should have a function to distribute project tokens to a specified
address. This function can only be called by the owner of the contract.
### Refund:
● If the minimum cap for either the presale or public sale is not reached, contributors
should be able to claim a refund.
## Design choices
- Use of OpenZeppelin Libraries: The contract uses OpenZeppelin libraries, which are widely trusted in the Ethereum community. They provide secure, standard, and audited implementations of ERC20 (for the token) and Ownable (for access control).

- Separate Phases for Presale and Public Sale: The contract has separate phases for presale and public sale. This allows the contract owner to manage each phase independently, including setting different rates, caps, and contribution limits for each phase.

- Immediate Token Distribution: Tokens are distributed immediately upon contribution. This simplifies the contract and provides instant gratification to contributors.

- Caps and Contribution Limits: The contract includes maximum caps on the total Ether that can be raised in each phase, as well as minimum and maximum contribution limits per participant. This allows the contract owner to control the scale of the sale and prevent any single participant from buying too many tokens.

- Refund Functionality: The contract includes a refund functionality in case the minimum cap for either the presale or public sale is not reached. This protects contributors and increases trust in the sale.

- Owner-Only Functions: Certain functions, such as starting and ending the sale phases and distributing tokens, can only be called by the owner of the contract. This provides control and security.

- Event Logging: The contract emits an event whenever tokens are purchased. This allows for easy tracking and auditing of all token purchases.

- Error Handling: The contract includes require statements with error messages throughout to ensure that functions are only called when it is valid to do so.
  ## Test script
  The test file includes two tests: testBuyTokens and testEndSale.
   The testBuyTokens function tests the buyTokens function of the TokenSale contract, and the testEndSale function tests the endSale function of the TokenSale contract.
