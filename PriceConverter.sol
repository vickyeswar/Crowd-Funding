//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./AggregatorV3Interface.sol";


library PriceConverter{
    function getPrice() internal view returns(uint256){
        // Address
        // im working with goerli test network, replace this address with your working network
        // visit this site and choose your network address
        // https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum 
        // address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 price,,,) = priceFeed.latestRoundData();
        //ETH in terms of USD
        return uint256(price * 1e10);
    }

    function getVersion() internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    // function that converts eth amount to usd
    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;        
    }
}
