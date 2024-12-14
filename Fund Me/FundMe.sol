// Get funds from Users
// Withdraw funds
// Set a minimum funding value in USD
// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {PriceConverter} from "../Library/PriceConverter.sol";

error NotOwner();

contract FundMe {

    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }


    function withdraw() public onlyOwner {

        // Removing all the funds from the mapping
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            addressToAmountFunded[funders[funderIndex]] = 0;
        }
        // Resetting the funders array back to empty
        funders = new address[](0);

        // Three ways of sending back eth to account
        // transfer
        // send
        // call

        
        // transfer
        // It throws error if transfer fails
        payable(msg.sender).transfer(address(this).balance);


        // send
        // send doesn't throw any error. It returns a boolean weather the send is successful or not
        // If not successful, throw an error to revert the transaction
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");

        // call
        // call doesn't throw any error. It returns a boolean and a bytes array. weather the call is successful or not
        // If not successful, throw an error to revert the transaction
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "You are not authorised");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }


    // If funders didn't call the fund() method, then these two solidity functions work as fallback functions
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}