//Get Funds from users
//Withdraw funds to the owner account
//Set a minimum funding value in USD 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    using  PriceConverter for uint;

    uint256 public  minimumUSD =5e14;
    address[] public funders ;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    address public owner;

    constructor(){
      owner = msg.sender;
    }
    function fund() public payable{
      require(msg.value.getConversionRate() >= minimumUSD, "You need to spend more ETH!");
      funders.push(msg.sender);
      addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value; 
    
    }
    function withdraw() public onlyOwner{
      for (uint funderIndex = 0; funderIndex < funders.length; funderIndex ++ ){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;
      }
      //reset the array
      funders = new address[](0);

      //there is three ways to withdraw funds 
      //transfer 
      /*payable(msg.sender).transfer(address(this).balance);
     
      //send
      bool sendSuccess = payable(msg.sender).send(address(this).balance);
      require(sendSuccess,"Send failed");*/

      //call
      (bool callSuccess, ) = payable(msg.sender).call{value : address(this).balance}("");
      require(callSuccess,"Call failed");
    }

    modifier onlyOwner() {
      require(msg.sender == owner,"Sender it not owner !");
      _;
    }   
}