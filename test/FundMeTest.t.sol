// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        // fundMe.i_owner was set in setUp(), during deployment
        // At that time, the deploying address was address(this) (the test contract)
        console.log("i_owner (set during deployment):", fundMe.i_owner());

        // msg.sender here is NOT address(this)
        // Foundry calls this test function from a separate test runner address (like 0x000...01)
        console.log("msg.sender (caller of this test):", msg.sender);

        // address(this) is the address of this test contract
        // This was the deployer of FundMe, and is the true i_owner
        console.log("address(this):", address(this));

        // This will pass ✅ because we deployed FundMe from address(this)
        assertEq(fundMe.i_owner(), address(this));

        // This will fail ❌ because msg.sender ≠ address(this) in test functions
        // Uncommenting this line would make the test fail:
        // assertEq(fundMe.i_owner(), msg.sender);
        //Testing
    }

    function testPriceFeedVersionAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
