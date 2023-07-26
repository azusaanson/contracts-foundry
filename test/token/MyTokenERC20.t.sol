// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../src/token/MyToken.sol";
import "../utils/Helper.sol";

contract MyTokenERC20Test is Test, Helper {
    MyToken public myToken;
    address public distributor = makeAddr("distributor");
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000;

    function setUp() public {
        myToken = new MyToken(distributor);
    }

    function testBasic() public {
        assertEq(myToken.name(), "MyToken");
        assertEq(myToken.symbol(), "MTK");
        assertEq(myToken.decimals(), 18);
        assertEq(myToken.totalSupply(), INITIAL_SUPPLY);
        assertEq(myToken.balanceOf(distributor), INITIAL_SUPPLY);
    }

    function testTransfer(uint256 amount, uint256 amount2) public {
        address to = makeAddr("to");
        address to2 = makeAddr("to2");

        vm.startPrank(distributor);
        amount = _zeroMod(amount, INITIAL_SUPPLY);
        myToken.transfer(to, amount);
        assertEq(myToken.balanceOf(to), amount);
        assertEq(myToken.balanceOf(distributor), INITIAL_SUPPLY - amount);
        vm.stopPrank();

        vm.startPrank(to);
        amount2 = _zeroMod(amount2, amount);
        myToken.transfer(to2, amount2);
        assertEq(myToken.balanceOf(to2), amount2);
        assertEq(myToken.balanceOf(to), amount - amount2);
        vm.stopPrank();
    }

    function testAllowance(
        uint256 amount,
        uint256 allowAmount,
        uint256 increaseAmount,
        uint256 decreaseAmount,
        uint256 toAmount
    ) public {
        address owner = makeAddr("owner");
        address spender = makeAddr("spender");
        address to = makeAddr("to");

        vm.startPrank(distributor);
        amount = _zeroMod(amount, INITIAL_SUPPLY);
        myToken.transfer(owner, amount);
        vm.stopPrank();

        vm.startPrank(owner);
        allowAmount = _zeroMod(allowAmount, amount);
        myToken.approve(spender, allowAmount);
        assertEq(myToken.allowance(owner, spender), allowAmount);

        increaseAmount = _zeroMod(increaseAmount, amount - allowAmount);
        myToken.increaseAllowance(spender, increaseAmount);
        allowAmount = allowAmount + increaseAmount;
        assertEq(myToken.allowance(owner, spender), allowAmount);

        decreaseAmount = _zeroMod(decreaseAmount, allowAmount);
        myToken.decreaseAllowance(spender, decreaseAmount);
        allowAmount = allowAmount - decreaseAmount;
        assertEq(myToken.allowance(owner, spender), allowAmount);
        vm.stopPrank();

        vm.startPrank(spender);
        toAmount = _zeroMod(toAmount, allowAmount);
        myToken.transferFrom(owner, to, toAmount);
        assertEq(myToken.balanceOf(to), toAmount);
        assertEq(myToken.balanceOf(owner), amount - toAmount);
        vm.stopPrank();
    }
}
