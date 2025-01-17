// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {Elevator} from "../src/Elevator.sol";

contract DeployElevator is Script {

    bool public hasBeenCalled;

    function isLastFloor(uint256 floor) external returns (bool) {
        bool result = hasBeenCalled;
        hasBeenCalled = true;
        return result;
    }

    function run() public {
        vm.startBroadcast();
        Elevator elevator = new Elevator();
        vm.stopBroadcast();

        console.log("Elevator top:", elevator.top());
        console.log("Elevator floor:", elevator.floor());
        elevator.goTo(1);
        console.log("Elevator top:", elevator.top());
        console.log("Elevator floor:", elevator.floor());

        
    }
}