// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

// 1. Unit: test a specific part of our code
// 2. Integration: test how our code is working with other parts of our code
// 3. Forked: test our code on a similated real environment
// 4. Staging: test our code on a real environemnt that is not prod

contract FundMeTest is Test {
    FundMe fundMe;
    address alice;

    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    // https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1&networkType=testnet&search=&testnetSearch=
    /**
     * Network: Ethereum Testnet
     * Aggregator: ETH/USD
     * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
     */

    // https://docs.chain.link/data-feeds/price-feeds/addresses?page=1&testnetPage=1&network=zksync&networkType=testnet&search=&testnetSearch=
    /**
     * Network: ZKsync Sepolia testnet
     * Aggregator: ETH/USD
     * Address: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
     */
    address constant PRICE_FEED_ADDRESS =
        0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        alice = makeAddr("alice");
        emit log_address(alice);
        vm.deal(alice, STARTING_BALANCE);
        //log_uint256(alice.balance);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testMessageSenderIsOwner() public {
        // us -> FundMeTest -> FundMe
        console.log("FundMeTest: fundMe.i_owner(): ", fundMe.i_owner()); // FundMeTest
        console.log("FundMeTest: address(this): ", address(this)); // FundMeTest
        console.log("US: msg.sender: ", msg.sender); // us
        //assertEq(fundMe.i_owner(), address(this));
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getAggregatorV3Version();
        console.log("getAggregatorV3Version: ", version);
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // next line should revert!
        // assert(This tx files/reverts)
        fundMe.fund(); // send 0 value
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(alice); // The next TX will be sent by Alice
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(alice);
        console.log("amountFunded: ", amountFunded);
        assertEq(amountFunded, SEND_VALUE);
    }
}
