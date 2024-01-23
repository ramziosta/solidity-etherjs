// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import {AggregatorV3Interface} from "./AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // answer is price of eth in USD
        uint256 ethPrice = uint256(answer * 1e10);
        return ethPrice;
    }

    function getConversionRate(uint256 ethAmount)
    internal
    view
    returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
    }

    function getVersion() internal view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
            .version();
    }
}
