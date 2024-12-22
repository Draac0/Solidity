// SPDX-License-Identifier: MIT

// This is an helper contract to get the chainlink price feed address
// We mock the price feed address in the test

pragma solidity 0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {console} from "forge-std/console.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed;
    }

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8;

    NetworkConfig public networkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            networkConfig = getSepoliaEthConfig();
        } else {
            networkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig()
        internal
        pure
        returns (NetworkConfig memory)
    {
        NetworkConfig memory sepoliaEthConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaEthConfig;
    }

    function getOrCreateAnvilEthConfig() internal returns (NetworkConfig memory) {
        if (networkConfig.priceFeed != address(0)) {
            return networkConfig;
        }

        // Mock price feed address
        //1. Deploy the mock price feed
        //2. Get the mock price feed address

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_ANSWER
        );
        vm.stopBroadcast();
        NetworkConfig memory anvilEthConfig = NetworkConfig({
            priceFeed: address(mockV3Aggregator)
        });

        return anvilEthConfig;
    }
}
