// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Helper {
    function _zeroMod(
        uint256 num1,
        uint256 num2
    ) internal pure returns (uint256) {
        if (num1 == 0 || num2 == 0) {
            return 0;
        }
        return num1 % num2;
    }
}
