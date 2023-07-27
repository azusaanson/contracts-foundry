// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../lib/forge-std/src/Test.sol";
import {MyGovernor} from "../../src/governance/MyGovernor.sol";
import {MyToken} from "../../src/token/MyToken.sol";
import {IVotes} from "../../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";
import "../utils/Helper.sol";

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
        assertEq(myGovernor.name(), "MyGovernor");
    }
}
