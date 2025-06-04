// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter{

    function getVersion() internal view returns (uint256){
      return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    function getPrice() internal view returns(uint256){
      AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
      (,int256 price,,,) = priceFeed.latestRoundData();
      return uint256(price *1e10);
    }

    function getConversionRate(uint ethAmount) internal view returns(uint256){
      //ex : ethPrice = 2000USD = 2000_000000000000000000 , ethAmount = 1_000000000000000000 , 1e36/1e18 = 1e18
      uint256 ethPrice = getPrice();
      uint ethAmountInUSD = (ethAmount * ethPrice) / 1e18;
      return ethAmountInUSD;
    }
}