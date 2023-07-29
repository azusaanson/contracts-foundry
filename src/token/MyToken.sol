// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IMyToken} from "./IMyToken.sol";
import {IVotes} from "../../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";
import {IERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Votes, ERC20Permit} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract MyToken is IMyToken, ERC20Votes {
    // ============ Constants ============
    string internal constant _NAME = "MyToken";
    string internal constant _SYMBOL = "MTK";
    uint256 internal constant _INITIAL_SUPPLY = 1_000_000_000;

    // ============ Storages ============
    address private _governor;

    // ============ Constructor ============
    constructor() ERC20(_NAME, _SYMBOL) ERC20Permit(_NAME) {
        super._mint(_msgSender(), _INITIAL_SUPPLY);
        _governor = _msgSender();
    }

    // ============ Modifiers ============
    modifier onlyGovernance() {
        require(_msgSender() == _governor, "MyToken: onlyGovernance");
        _;
    }

    // ============ External View Functions ============
    function initialSupply() external pure returns (uint256) {
        return _INITIAL_SUPPLY;
    }

    function governor() external view returns (address) {
        return _governor;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) external pure returns (bool) {
        return
            interfaceId == type(IERC20).interfaceId ||
            interfaceId == type(IVotes).interfaceId;
    }

    // ============ External Only Governance Functions ============
    function updateGovernor(address newGovernor) external onlyGovernance {
        _governor = newGovernor;
    }

    function mint(uint256 amount) external onlyGovernance {
        super._mint(_msgSender(), amount);
    }

    function burn(uint256 amount) external onlyGovernance {
        super._burn(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) external onlyGovernance {
        super._spendAllowance(account, _msgSender(), amount);
        super._burn(account, amount);
    }

    // ============ External Override Functions ============
    function delegates(
        address account
    ) public view virtual override(ERC20Votes, IVotes) returns (address) {
        if (super.delegates(account) == address(0)) {
            return account;
        }
        return super.delegates(account);
    }
}
