// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minUSD = 5 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        require(
            (msg.value).getConversionRate() >= minUSD,
            "didnt sent enough eth"
        );

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdrawAllMoney() public {
        uint256 funderIndex = 0;
        uint256 n = funders.length;

        for (uint256 i = funderIndex; i < n; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        //resets the address to a new array
        funders = new address[](0);

        //three ways to withdraw the tokens

        // transfer: there is a limit of 2300 Gas eth. if it fails it gives an error doesnt
        // msg.sender is of type sender address
        // payable is of type payable address
        // transfer the funds from the sender to the payable(receiver's) address--this refers to the sender
        //
        payable(msg.sender).transfer(address(this).balance);

        // send: there is a limit of 2300 eth. if it fails it gives a boolean: it won't error
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send was not successful");

        // it doesnt hav a limit to the amount of gas used,
        // it returns a boolean if it is successful or it fails
        // call no ABI needed, and it is a direct code that we can write
        // it can also call other functions that can return values that we can use
        // this type of code is very low level and high customization
        // ("") is where we call other functions
        // bytes dataReturned is the returned values from the functions that we call.. bytes are arrays

        (bool callSuccess, ) = payable(msg.sender)
            .call{                            // here we can write a custom function,
                value: address(this).balance //but in this case we are using the previous examples
            }
        ("");
        require(callSuccess, "Call was not successful");
    }
}
