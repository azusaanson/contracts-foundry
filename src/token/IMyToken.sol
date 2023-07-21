// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { IERC20 } from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { IERC165 } from "../../lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";

interface IMyToken is IERC20, IERC165 {

}
