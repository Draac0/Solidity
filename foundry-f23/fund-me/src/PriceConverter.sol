//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {console} from "forge-std/console.sol";

library PriceConverter {
    function getVersion(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        return priceFeed.version();
    }

    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // Price in ETH in terms of USD
        // 2000.00000000 (It doesn't return like this as there are no decimals in the Solidity)
        // Convert the USD to ETH
        // We have to multiply by 1e10 to match
        console.log("answer: ", answer);
        console.log("Price in ETH: ", uint256(answer * 1e10));
        return uint256(answer * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        console.log("ethPrice: ", ethPrice);
        return (ethPrice * ethAmount) / 1e18;
    }
}
// 20,00000,00000 2e11
// 20,00000,00000,00000,00000 2e21
// 2e21*1e18 = (2e39)/1e18 = 2e21
// 2e21*1e16 = (2e37)/1e18 = 2e19
// 2e21*1e10 = (2e31)/1e18 = 2e13