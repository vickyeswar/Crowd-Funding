//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract CrowdFund{
    using PriceConverter for uint256;

    uint256 public miniUSD = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmoundFunded;
    address public owner;

    // set contract deployer as owner of the contract
    constructor(){
        owner = msg.sender;
    }

    function fund() public payable{
        //contributors can fund their amount through this function
        // if sender amount is less than 1ETH, Error Message will popup
        require (msg.value.getConversionRate() >= miniUSD, "Insufficient Amount!, Minimum Amount is 50USD");
        // store funder's infromations in array
        funders.push(msg.sender);
        addressToAmoundFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner{
        // for loop that reset the amount to 0 after owner of the contract withdraws all the amount
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++){
            address funder = funders[funderIndex];
            addressToAmoundFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        // transfer amount to the owner
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    // modifier sets deployer as owner before withdrawal functions starts
    modifier onlyOwner{
        require(msg.sender == owner, "Sender is not Owner");
        _;
    }
    // if funder send amount directly instead of fund function this will trigger
    receive() external payable {
    fund();
    }
    
    fallback() external payable {
    fund();
    }
}
