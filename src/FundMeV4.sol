// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

    error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    // constant makes more gas efficient by reducing storage space
    uint256 public constant MINUSD = 5 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }
    // immutable also reduces storage space and less gas use
    address public immutable i_owner;

    function fund() public payable {
        require(
            (msg.value).getConversionRate() >= MINUSD,
            "didnt sent enough eth"
        );

        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }


    modifier onlyi_owner() {
        // require(msg.sender == i_owner, "i_owner only authorised");
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function withdrawAllMoney() public onlyi_owner {
        require(msg.sender == i_owner, "you are not authorised");

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

