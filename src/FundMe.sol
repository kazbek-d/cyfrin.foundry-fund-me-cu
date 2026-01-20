// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

error FundMe_NotOwner();

// Get funds from users
// Withdraw funds
// Set minimum funds value in USD
contract FundMe {
    using PriceConverter for uint256;
    using PriceConverter for address;

    // 5 USD => 5e18 because of presigion
    uint256 public constant MINIMUM_USD = 5e18;

    address[] private s_funders;
    mapping(address funder => uint256 amountFunded)
        private s_addressToAmountFunded;

    address private immutable i_owner;

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
    //address constant PRICE_FEED_ADDRESS = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address public immutable i_price_feed_address;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        i_price_feed_address = priceFeed;
    }

    // Allow users to send $
    // Have a minimum $ to sent
    function fund() public payable {
        require(
            msg.value.getConversionRate(i_price_feed_address) >= MINIMUM_USD,
            "didn't send enough ETH"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    /* https://solidity-by-example.org/
     * Sending ETH From a Contract.
     * An exploration of three methods for sending Ether from a contract in Solidity: transfer, send, and call.
     *  - transfer (2300 gas, throws error)
     *  - send (2300 gas, returns bool)
     *  - call (forward all gas or set gas, returns bool)
     */
    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // use here anz of: transfer, send, and call

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    // msg.sender = address
    // payable(msg.sender) = payable address

    // 1. transfer (2300 gas, throws error)
    function transfer() private {
        payable(msg.sender).transfer(address(this).balance);
        // automaticly revert in case of failier
    }

    // 2. send (2300 gas, returns bool)
    function send() private returns (bool) {
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");
        return sendSuccess;
    }

    // 3. call (forward all gas or set gas, returns bool)
    // https://solidity-by-example.org/call/
    function call() private returns (bool) {
        // we just sending the funds, no need to specify the function name
        bytes memory functionToCall = "";
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }(functionToCall);
        require(callSuccess, "Call failed");
        return callSuccess;
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not the owner");
        if (msg.sender != i_owner) {
            revert FundMe_NotOwner();
        }
        _;
    }

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    /**
     * View / Pure function ( Getters )
     */
    function getAggregatorV3Version() public view returns (uint256) {
        return i_price_feed_address.getVersion();
    }

    function getAddressToAmountFunded(
        address fundingAddress
    ) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}
