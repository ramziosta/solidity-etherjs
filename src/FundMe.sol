// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
// allow users to get funds -- public
// allow users to send funds -- public
// set minimum fund amount

import { AggregatorV3Interface } from "./AggregatorV3Interface.sol";
//direct import from github
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minUSD = 5 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        require(getConversionRate(msg.value) >= minUSD, "didnt sent enough eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public {}
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // answer is price of eth in USD
        uint256 ethPrice = uint256(answer * 1e10);
        return ethPrice;
    }

    function getConversionRate(uint256 ethAmount)
    public
    view
    returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
    }

    function getVersion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
            .version();
    }
    //address 0x694AA1769357215DE4FAC081bf1f309aDC325306 for eth sepolia/usd
    //ABI
}
