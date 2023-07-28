// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../lib/forge-std/src/Test.sol";
import {MyGovernor} from "../../src/governance/MyGovernor.sol";
import {MyToken} from "../../src/token/MyToken.sol";
import {IVotes} from "../../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";
import "../utils/Helper.sol";
import {IGovernor} from "../../lib/openzeppelin-contracts/contracts/governance/IGovernor.sol";

contract MyGovernorTest is Test, Helper {
    MyGovernor public myGovernor;
    MyToken public myToken;
    address public distributor = makeAddr("distributor");
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000;

    function setUp() public {
        myToken = new MyToken(distributor);
        myGovernor = new MyGovernor(IVotes(address(myToken)));
    }

    function testBasic() public {
        vm.roll(myGovernor.clock() + 1);
        assertEq(myGovernor.name(), "MyGovernor");
        assertEq(myGovernor.version(), "1");
        assertEq(myGovernor.votingDelay(), 7200);
        assertEq(myGovernor.votingPeriod(), 50400);
        assertEq(
            myGovernor.getVotes(distributor, myGovernor.clock() - 1),
            INITIAL_SUPPLY
        );
    }

    function testProposal() public {
        // proposal
        string memory description = "proposal #1 : Description";
        bytes32 descriptionHash = keccak256(bytes(description));
        address[] memory myTokenAddrs = new address[](1);
        myTokenAddrs[0] = address(myToken);
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        address to = makeAddr("to");
        bytes[] memory callDatas = new bytes[](1);
        callDatas[0] = abi.encodeWithSignature(
            "transfer(address,uint256)",
            to,
            1_000
        );
        uint256 proposalId = myGovernor.hashProposal(
            myTokenAddrs,
            values,
            callDatas,
            descriptionHash
        );

        // addrs
        address governorTreasury = address(myGovernor);
        address proposer = makeAddr("proposer");
        address voteAddrFor = makeAddr("voteAddr1");
        address voteAddrAgainst = makeAddr("voteAddr2");

        // transfer token to addrs
        vm.roll(myGovernor.clock() + 1);

        vm.startPrank(distributor);
        myToken.transfer(governorTreasury, 10_000_000);
        myToken.transfer(proposer, 1_000_000);
        myToken.transfer(voteAddrFor, 100_000_000);
        assertEq(myToken.getVotes(voteAddrFor), 100_000_000);
        myToken.transfer(voteAddrAgainst, 40_000_000);
        assertEq(myToken.getVotes(voteAddrAgainst), 40_000_000);
        vm.stopPrank();

        // create proposal
        vm.startPrank(proposer);
        myGovernor.propose(myTokenAddrs, values, callDatas, description);
        vm.stopPrank();

        uint256 snapshot = myGovernor.clock() + 7200;
        uint256 deadline = snapshot + 50400;
        assertEq(
            uint256(myGovernor.state(proposalId)),
            uint256(IGovernor.ProposalState.Pending)
        );
        assertEq(myGovernor.proposalSnapshot(proposalId), snapshot);
        assertEq(myGovernor.proposalDeadline(proposalId), deadline);
        assertEq(myGovernor.proposalProposer(proposalId), proposer);

        // start voting
        vm.roll(myGovernor.clock() + 7201);
        assertEq(
            uint256(myGovernor.state(proposalId)),
            uint256(IGovernor.ProposalState.Active)
        );

        uint8 againstVote = 0;
        uint8 forVote = 1;

        vm.startPrank(voteAddrFor);
        myGovernor.castVote(proposalId, forVote);
        vm.stopPrank();

        vm.startPrank(voteAddrAgainst);
        myGovernor.castVote(proposalId, againstVote);
        vm.stopPrank();

        // check voting result
        vm.roll(myGovernor.clock() + 50401);
        assertEq(
            uint256(myGovernor.state(proposalId)),
            uint256(IGovernor.ProposalState.Succeeded)
        );

        // execute proposal
        vm.startPrank(proposer);
        myGovernor.execute(
            myTokenAddrs,
            values,
            callDatas,
            keccak256(bytes("proposal #1 : Description"))
        );
        assertEq(
            uint256(myGovernor.state(proposalId)),
            uint256(IGovernor.ProposalState.Executed)
        );
        assertEq(myToken.balanceOf(to), 1_000);
        assertEq(myToken.balanceOf(governorTreasury), 10_000_000 - 1_000);
        vm.stopPrank();
    }
}
