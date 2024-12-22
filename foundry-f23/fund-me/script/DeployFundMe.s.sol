// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Before the transaction starts, get the price feed address from the helper contract
        // Before vm.startBroadCast() (it's not a transaction and no gas fee)

        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.networkConfig();

        vm.startBroadcast(); // gas fee starts form here
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
