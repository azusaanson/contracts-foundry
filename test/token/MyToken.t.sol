// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../lib/forge-std/src/Test.sol";
import "../../src/token/MyToken.sol";
import "../utils/Helper.sol";
import {MyGovernor} from "../../src/governance/MyGovernor.sol";
import {IVotes} from "../../lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol";

contract MyTokenTest is Test, Helper {
    MyToken public myToken;
    MyGovernor public myGovernor;
    address public distributor = makeAddr("distributor");
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000;

    function setUp() public {
        vm.startPrank(distributor);
        myToken = new MyToken();
        myGovernor = new MyGovernor(IVotes(address(myToken)));
        myToken.updateGovernor(address(myGovernor));
        vm.stopPrank();
    }

    function testBasic() public {
        assertEq(myToken.name(), "MyToken");
        assertEq(myToken.symbol(), "MTK");
        assertEq(myToken.decimals(), 18);
        assertEq(myToken.totalSupply(), INITIAL_SUPPLY);
        assertEq(myToken.balanceOf(distributor), INITIAL_SUPPLY);
        assertEq(myToken.getVotes(distributor), INITIAL_SUPPLY);
        assertEq(myToken.governor(), address(myGovernor));
    }

    function testTransfer(uint256 amount, uint256 amount2) public {
        address to = makeAddr("to");
        address to2 = makeAddr("to2");

        vm.startPrank(distributor);
        amount = _zeroMod(amount, INITIAL_SUPPLY);
        myToken.transfer(to, amount);
        assertEq(myToken.balanceOf(to), amount);
        assertEq(myToken.getVotes(to), amount);
        assertEq(myToken.balanceOf(distributor), INITIAL_SUPPLY - amount);
        assertEq(myToken.getVotes(distributor), INITIAL_SUPPLY - amount);
        vm.stopPrank();

        vm.startPrank(to);
        amount2 = _zeroMod(amount2, amount);
        myToken.transfer(to2, amount2);
        assertEq(myToken.balanceOf(to2), amount2);
        assertEq(myToken.getVotes(to2), amount2);
        assertEq(myToken.balanceOf(to), amount - amount2);
        assertEq(myToken.getVotes(to), amount - amount2);
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

    function testBurn(
        uint256 governorAmount,
        uint256 burnFromAmount,
        uint256 burnAmount,
        uint256 allowAmount,
        uint256 burnBurnFromAmount
    ) public {
        address governor = address(myGovernor);
        address burnFromAddr = makeAddr("addr");

        // init balance
        vm.startPrank(distributor);
        governorAmount = _zeroMod(governorAmount, INITIAL_SUPPLY);
        burnFromAmount = _zeroMod(
            burnFromAmount,
            INITIAL_SUPPLY - governorAmount
        );
        myToken.transfer(governor, governorAmount);
        myToken.transfer(burnFromAddr, burnFromAmount);
        vm.stopPrank();

        // test burn
        vm.startPrank(governor);
        burnAmount = _zeroMod(burnAmount, governorAmount);
        myToken.burn(burnAmount);
        assertEq(myToken.totalSupply(), INITIAL_SUPPLY - burnAmount);
        assertEq(myToken.balanceOf(governor), governorAmount - burnAmount);
        assertEq(myToken.getVotes(governor), governorAmount - burnAmount);
        vm.stopPrank();

        // test burnFrom
        vm.startPrank(burnFromAddr);
        allowAmount = _zeroMod(allowAmount, myToken.balanceOf(burnFromAddr));
        myToken.approve(governor, allowAmount);
        vm.stopPrank();

        vm.startPrank(governor);
        burnBurnFromAmount = _zeroMod(burnBurnFromAmount, allowAmount);
        myToken.burnFrom(burnFromAddr, burnBurnFromAmount);
        assertEq(
            myToken.totalSupply(),
            INITIAL_SUPPLY - burnAmount - burnBurnFromAmount
        );
        assertEq(
            myToken.balanceOf(burnFromAddr),
            burnFromAmount - burnBurnFromAmount
        );
        assertEq(
            myToken.getVotes(burnFromAddr),
            burnFromAmount - burnBurnFromAmount
        );
        vm.stopPrank();
    }
}
