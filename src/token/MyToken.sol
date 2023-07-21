// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { IMyToken } from "./IMyToken.sol";
import { IERC20 } from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { ERC20 } from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { ERC20Votes, ERC20Permit } from "../../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract MyToken is IMyToken, ERC20Votes {
    // ============ Constants ============
    string internal constant _NAME = 'MyToken';
    string internal constant _SYMBOL = 'MYTOKEN';
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000;

    // ============ Constructor ============
    constructor(address distributor) ERC20(_NAME, _SYMBOL) ERC20Permit(_NAME) {
        super._mint(distributor, INITIAL_SUPPLY);
    }

    // ============ External Functions ============
    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == type(IERC20).interfaceId;
    }
}
