// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

import {CoinFlip} from "../src/CoinFlip.sol";

contract DeployCoinFlip is Script {
    function run() external {
        vm.startBroadcast();
        CoinFlip cf = new CoinFlip();
        vm.stopBroadcast();
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        for (uint i = 0; i < 10; i++) {
            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 coinFlip = blockValue / FACTOR;
            if (coinFlip == 1) {
                cf.flip(true);
            } else {
                cf.flip(false);
            }
            vm.roll(block.number + 1);
        }
        assert(cf.consecutiveWins() == 10);
    }
}
