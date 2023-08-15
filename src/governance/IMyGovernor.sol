// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IGovernor} from "../../lib/openzeppelin-contracts/contracts/governance/IGovernor.sol";

interface IMyGovernor {
    function proposalDetail(
        uint256 proposalId
    )
        external
        view
        returns (
            IGovernor.ProposalState state,
            uint256 snapshot,
            uint256 deadline,
            address proposer
        );
}
