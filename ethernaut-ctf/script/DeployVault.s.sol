//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vault} from "../src/Vault.sol";

contract DeployVault is Script {
    function run() external {
        vm.startBroadcast();
        bytes32 password = "secret-password";
        Vault vault = new Vault(password);
        vm.stopBroadcast();
        bool lockedStateAfterDeploy = vault.locked();
        console.log("Vault deployed at:", address(vault));
        console.log("Vault locked state after deploy:", lockedStateAfterDeploy);
        console.log("Vault password:");
        console.logBytes32(password);

        bytes32 privatePassword = vm.load(address(vault), bytes32(uint256(1)));
        console.logBytes32(privatePassword);
        vault.unlock(privatePassword);
        bool lockedStateAfterUnlock = vault.locked();
        console.log("Vault locked state after unlock:", lockedStateAfterUnlock);
    }
}
