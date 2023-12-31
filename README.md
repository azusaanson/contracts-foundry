# contracts-foundry

- [Get Started](#get-started)
- [Build Compile and Test](#build-compile-and-test)
- [Generate ABIs](#generate-abis)
- [Deploy](#deploy)
- [MyToken](#mytoken)
- [MyGovernor](#mygovernor)

## Get Started

### Install Dependencies

- install foundry

```
curl -L https://foundry.paradigm.xyz | bash
```

```
foundryup
```

### Vscode Extension

- [solidity by Juan Blanco](https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity)

### Useful Links

- [foundry](https://book.getfoundry.sh/)
- [openzeppelin](https://docs.openzeppelin.com/contracts/4.x/)
- [openzeppelin contracts repository](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master)
- [openzeppelin wizard](https://wizard.openzeppelin.com/)

## Build Compile and Test

- build

```
forge build
```

- compile

```
forge compile
```

- test

```
forge test
```

## Generate ABIs

```
make gen_abi
```

## Deploy

### local

- setup local node

```
anvil
```

- (optional) setup .env LOCAL_PRIVATE_KEY, LOCAL_TOKEN_ADDR and LOCAL_GOVERNOR_ADDR

- build and deploy

  - MyToken

  ```
  make deploy_mytoken_local
  ```

  - MyGovernor

  ```
  make deploy_mygovernor_local
  ```

- cheating in anvil

  - mine one block in anvil node

  ```
  make anvil_mine_block
  ```

  - mine 7200 blocks (one day) in anvil node

  ```
  make anvil_mine_blocks_one_day
  ```

  - mine 50400 blocks (one week) in anvil node (a long wait, use carefully)

  ```
  make anvil_mine_blocks_one_week
  ```

## MyToken

### View

ERC20:

- name() = MyToken
- symbol() = MYTOKEN
- decimals() = 0
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

Permit:

- permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)

Votes:

- delegate(address delegatee)
- delegateBySig(address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s)

OnlyGovernance:

- updateGovernor(address newGovernor)
- mint(uint256 amount)
- burn(uint256 amount)
- burnFrom(address account, uint256 amount)

## MyGovernor

### View

Governor:

- name() = MyGovernor
- version() = 1
- clock()
- CLOCK_MODE()
- votingDelay() = 7200(1 day)
- votingPeriod() = 50400(1 week)

Proposal:

- hashProposal(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
- state(uint256 proposalId)
- proposalThreshold() = 1000
- proposalDetail(uint256 proposalId) = (state, snapshot, deadline, proposer)
- proposalSnapshot(uint256 proposalId)
- proposalDeadline(uint256 proposalId)
- proposalProposer(uint256 proposalId)

GetVotesByAddress:

- getVotes(address account, uint256 timepoint)
- getVotesWithParams(address account, uint256 timepoint, bytes memory params)

Counting:

- COUNTING_MODE()
- hasVoted(uint256 proposalId, address account)
- proposalVotes(uint256 proposalId) = (againstVotes, forVotes, abstainVotes)

Quorum:

- quorumNumerator()
- quorumNumerator(uint256 timepoint)
- quorumDenominator()
- quorum(uint256 timepoint)

ERC165:

- supportsInterface(bytes4 interfaceId)

### Post

Proposal:

- propose(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, string memory description)
- execute(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)
- cancel(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash)

Vote:

- castVote(uint256 proposalId, uint8 support)
- castVoteWithReason(uint256 proposalId, uint8 support, string calldata reason)
- castVoteWithReasonAndParams(uint256 proposalId, uint8 support, string calldata reason, bytes memory params)
- castVoteBySig(uint256 proposalId, uint8 support, uint8 v, bytes32 r, bytes32 s)
- castVoteWithReasonAndParamsBySig(uint256 proposalId, uint8 support, string calldata reason, bytes memory params, uint8 v, bytes32 r, bytes32 s)

ERC165:

- onERC721Received(address, address, uint256, bytes memory)
- onERC1155Received(address, address, uint256, uint256, bytes memory)
- onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory)

OnlyGovernance:

- relay(address target, uint256 value, bytes calldata data)
- updateQuorumNumerator(uint256 newQuorumNumerator)
