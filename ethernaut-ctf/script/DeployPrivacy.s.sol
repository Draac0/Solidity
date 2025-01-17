// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {Privacy} from "../src/Privacy.sol";

contract DeployPrivacy is Script {
    function run() public {
        vm.startBroadcast();
        bytes32[3] memory data = [bytes32(uint256(232398723981379)), bytes32(uint256(97432947932)), bytes32(uint256(39847398))];
        Privacy privacy = new Privacy(data);
        vm.stopBroadcast();

        bytes32 data0 = vm.load(address(privacy), bytes32(uint256(3)));
        bytes32 data1 = vm.load(address(privacy), bytes32(uint256(4)));
        bytes32 data2 = vm.load(address(privacy), bytes32(uint256(5)));

        console.log("data0:");
        console.logBytes32(data0);
        console.log("data1:");
        console.logBytes32(data1);
        console.log("data2:");
        console.logBytes32(data2);

        bytes16 key = bytes16(data2);
        console.log("Privacy locked:", privacy.locked());
        privacy.unlock(key);
        console.log("Privacy unlocked:", privacy.locked());
    }
}
