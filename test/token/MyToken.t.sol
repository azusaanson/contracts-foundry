// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../src/token/MyToken.sol";
import "../utils/Helper.sol";

contract MyTokenTest is Test, Helper {
    MyToken public myToken;
    address public distributor = makeAddr("distributor");
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000;

    function setUp() public {
        myToken = new MyToken(distributor);
    }

    function testBurn(
        uint256 amount,
        uint256 burnAmount1,
        uint256 allowAmount,
        uint256 burnAmount2
    ) public {
        address addr1 = makeAddr("addr1");
        address addr2 = makeAddr("addr2");

        vm.startPrank(distributor);
        amount = _zeroMod(amount, INITIAL_SUPPLY);
        myToken.transfer(addr1, amount);
        vm.stopPrank();

        vm.startPrank(addr1);
        burnAmount1 = _zeroMod(burnAmount1, amount);
        myToken.burn(burnAmount1);
        assertEq(myToken.totalSupply(), INITIAL_SUPPLY - burnAmount1);
        assertEq(myToken.balanceOf(addr1), amount - burnAmount1);
        allowAmount = _zeroMod(allowAmount, myToken.balanceOf(addr1));
        myToken.approve(addr2, allowAmount);
        vm.stopPrank();

        vm.startPrank(addr2);
        burnAmount2 = _zeroMod(burnAmount2, allowAmount);
        myToken.burnFrom(addr1, burnAmount2);
        assertEq(
            myToken.totalSupply(),
            INITIAL_SUPPLY - burnAmount1 - burnAmount2
        );
        assertEq(myToken.balanceOf(addr1), amount - burnAmount1 - burnAmount2);
        vm.stopPrank();
    }
}
