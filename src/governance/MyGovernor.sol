// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IMyGovernor} from "./IMyGovernor.sol";
import {IVotes} from "../../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";
import {Governor} from "../../lib/openzeppelin-contracts/contracts/governance/Governor.sol";
import {GovernorVotes} from "../../lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol";
import {GovernorCountingSimple} from "../../lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol";
import {GovernorVotesQuorumFraction} from "../../lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";

contract MyGovernor is
    IMyGovernor,
    GovernorVotesQuorumFraction,
    GovernorCountingSimple
{
    // ============ Constants ============
    string internal constant _NAME = "MyGovernor";
    uint256 internal constant _QUORUM_NUMERATOR = 10; // 10%
    uint256 internal constant _VOTING_DELAY = 7200; // 1 day
    uint256 internal constant _VOTING_PERIOD = 50400; // 1 week

    // ============ Constructor ============
    constructor(
        IVotes tokenAddress
    )
        Governor(_NAME)
        GovernorVotes(tokenAddress)
        GovernorVotesQuorumFraction(_QUORUM_NUMERATOR)
    {}

    // ============ External Functions ============
    function proposalDetail(
        uint256 proposalId
    )
        external
        view
        returns (
            ProposalState state,
            uint256 snapshot,
            uint256 deadline,
            address proposer
        )
    {
        return (
            super.state(proposalId),
            super.proposalSnapshot(proposalId),
            super.proposalDeadline(proposalId),
            super.proposalProposer(proposalId)
        );
    }

    function votingDelay() public pure override returns (uint256) {
        return _VOTING_DELAY;
    }

    function votingPeriod() public pure override returns (uint256) {
        return _VOTING_PERIOD;
    }
}
