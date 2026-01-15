// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
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

    function run() external returns (FundMe) {
        vm.startBroadcast();
        FundMe fundMe = new FundMe(PRICE_FEED_ADDRESS);
        vm.stopBroadcast();
        return fundMe;
    }
}
