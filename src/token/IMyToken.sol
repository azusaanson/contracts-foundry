// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC165} from "../../lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";
import {IVotes} from "../../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";

interface IMyToken is IERC20, IERC165, IVotes {
    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;
}
