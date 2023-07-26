# contracts-foundry

- [Compile and Test](#compile-and-test/)
- [Vscode Extension](#vscode-extension/)
- [MyToken](#mytoken/)
- [MyGovernor](#my-governor/)

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

### View

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

### Post

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

- permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)

Votes:

- delegate(address delegatee)
- delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s)

## MyGovernor

### View

Governor:

- name()
- version()
- clock()
- CLOCK_MODE()
- votingDelay()
- votingPeriod()

Proposal:

- hashProposal(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
- state(uint256 proposalId)
- proposalThreshold()
- proposalSnapshot(uint256 proposalId)
- proposalDeadline(uint256 proposalId)
- proposalProposer(uint256 proposalId)

GetVotesByAddress:

- getVotes(address account, uint256 timepoint)
- getVotesWithParams(
  address account,
  uint256 timepoint,
  bytes memory params
  )

Counting:

- COUNTING_MODE()
- hasVoted(uint256 proposalId, address account)
- proposalVotes(
  uint256 proposalId
  )

Quorum:

- quorumNumerator()
- quorumNumerator(uint256 timepoint)
- quorumDenominator()
- quorum(uint256 timepoint)

ERC165:

- supportsInterface(bytes4 interfaceId)

### Post

Proposal:

- propose(
  address[] memory targets,
  uint256[] memory values,
  bytes[] memory calldatas,
  string memory description
  )
- execute(
  address[] memory targets,
  uint256[] memory values,
  bytes[] memory calldatas,
  bytes32 descriptionHash
  )
- cancel(
  address[] memory targets,
  uint256[] memory values,
  bytes[] memory calldatas,
  bytes32 descriptionHash
  )

Vote:

- castVote(uint256 proposalId, uint8 support)
- castVoteWithReason(
  uint256 proposalId,
  uint8 support,
  string calldata reason
  )
- castVoteWithReasonAndParams(
  uint256 proposalId,
  uint8 support,
  string calldata reason,
  bytes memory params
  )
- castVoteBySig(
  uint256 proposalId,
  uint8 support,
  uint8 v,
  bytes32 r,
  bytes32 s
  )
- castVoteWithReasonAndParamsBySig(
  uint256 proposalId,
  uint8 support,
  string calldata reason,
  bytes memory params,
  uint8 v,
  bytes32 r,
  bytes32 s
  )

ERC165:

- onERC721Received(address, address, uint256, bytes memory)
- onERC1155Received(
  address,
  address,
  uint256,
  uint256,
  bytes memory
  )
- onERC1155BatchReceived(
  address,
  address,
  uint256[] memory,
  uint256[] memory,
  bytes memory
  )

OnlyGovernance:

- relay(address target, uint256 value, bytes calldata data)
- updateQuorumNumerator(uint256 newQuorumNumerator)
