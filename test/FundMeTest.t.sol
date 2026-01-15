// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

// 1. Unit: test a specific part of our code
// 2. Integration: test how our code is working with other parts of our code
// 3. Forked: test our code on a similated real environment
// 4. Staging: test our code on a real environemnt that is not prod

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testMessageSenderIsOwner() public {
        // us -> FundMeTest -> FundMe
        console.log("FundMeTest: fundMe.i_owner(): ", fundMe.i_owner()); // FundMeTest
        console.log("FundMeTest: address(this): ", address(this)); // FundMeTest
        console.log("US: msg.sender: ", msg.sender); // us
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getAggregatorV3Version();
        console.log("getAggregatorV3Version: ", version);
        assertEq(version, 4);
    }
}
