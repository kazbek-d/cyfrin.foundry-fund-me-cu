// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public {
        console.log("Some text");
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testMessageSenderIsOwner() public {
        // us -> FundMeTest -> FundMe
        console.log("FundMeTest: fundMe.i_owner(): ", fundMe.i_owner()); // FundMeTest
        console.log("FundMeTest: address(this): ", address(this)); // FundMeTest
        console.log("US: msg.sender: ", msg.sender); // us
        assertEq(fundMe.i_owner(), address(this));
    }
}
