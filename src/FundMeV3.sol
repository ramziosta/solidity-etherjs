// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minUSD = 5 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;

    constructor() {
        owner = msg.sender;
    }
// makes a red button because its payable
    function fund() public payable {
        require(
            (msg.value).getConversionRate() >= minUSD,
            "didnt sent enough eth"
        );

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    // modifier function it changes the behavior of the withdraw
    // set rules that only owner is able to withdraw
    // we can have a similar withdraw function with out the modifier for other users

    modifier onlyOwner() {
        require(msg.sender == owner, "owner only authorised");
        // this is executed after the require is met
        // if it was the other way around it will execute the function
        // then it execute the require()
        _;
    }
// makes orange button
    function withdrawAllMoney() public onlyOwner {
        require(msg.sender == owner, "you are not authorised");

        uint256 funderIndex = 0;
        uint256 n = funders.length;

        for (uint256 i = funderIndex; i < n; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        payable(msg.sender).transfer(address(this).balance);

        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send was not successful");

        (bool callSuccess, ) = payable(msg.sender).call{
                value: address(this).balance
            }("");
        require(callSuccess, "Call was not successful");
    }

}

//rest of the public buttons are blue