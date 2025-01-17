// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import {Token} from "../src/Token.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract DeployToken is Script {
    address user = makeAddr("user");
    address random = makeAddr("random");

    function run() public {
        Token token = new Token(100000);
        token.transfer(user, 20);

        uint256 userBalanceBefore = token.balanceOf(user);
        console.log("User balance: ", userBalanceBefore);

        vm.prank(user);
        token.transfer(random, 21);
        vm.stopPrank();

        uint256 userBalanceAfter = token.balanceOf(user);
        console.log("User balance: ", userBalanceAfter);
    }
}
