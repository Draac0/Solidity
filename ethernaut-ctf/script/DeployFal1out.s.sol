// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Fallout} from "../src/Fal1out.sol";

contract DeployFal1out is Script {
    function run() external {
        console.log("Deploying Fal1out...");
        console.log(address(this));
        vm.startBroadcast();
        Fallout f = new Fallout();
        vm.stopBroadcast();
        console.log(f.owner());
        vm.deal(address(this), 1 ether);
        f.Fal1out{value: 0.1 ether}();
        assert(f.owner() == address(this));
    }
}
