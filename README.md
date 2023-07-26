# contracts-foundry

- [Compile and Test](#compile-and-test/)
- [Vscode Extension](#vscode-extension/)
- [MyToken](#mytoken/)

## Compile and Test

- Compile

```
forge compile
```

- Test

```
forge test
```

## Vscode Extension

- [solidity by Juan Blanco](https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity)

## MyToken

### External (or Public) Functions:

#### view:

ERC20:

- name()
- symbol()
- decimals()
- totalSupply()
- balanceOf(address account)
- allowance(address owner, address spender)

ERC165:

- supportsInterface(bytes4 interfaceId)

EIP712:

- eip712Domain()

Permit:

- nonces(address owner)
- DOMAIN_SEPARATOR()

Votes:

- clock()
- CLOCK_MODE()
- checkpoints(address account, uint32 pos)
- numCheckpoints(address account)
- delegates(address account)
- getVotes(address account)
- getPastVotes(address account, uint256 timepoint)
- getPastTotalSupply(uint256 timepoint)

#### post:

ERC20:

- transfer(address to, uint256 amount)
- approve(address spender, uint256 amount)
- transferFrom(address from, address to, uint256 amount)
- increaseAllowance(address spender, uint256 addedValue)
- decreaseAllowance(address spender, uint256 subtractedValue)

Burn:

- burn(uint256 amount)
- burnFrom(address account, uint256 amount)

Permit:

- permit(
  address owner,
  address spender,
  uint256 value,
  uint256 deadline,
  uint8 v,
  bytes32 r,
  bytes32 s
  )

Votes:

- delegate(address delegatee)
- delegateBySig(
  address delegatee,
  uint256 nonce,
  uint256 expiry,
  uint8 v,
  bytes32 r,
  bytes32 s
  )
