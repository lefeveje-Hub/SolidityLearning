// SPDX-License-Identifier: MIT
// This line specifies the license for the code - MIT is a popular open source license

pragma solidity ^0.8.18;
// Specifies the Solidity compiler version to use - must be at least 0.8.18 but less than 0.9.0

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; 
// Imports Chainlink's price feed interface to interact with their oracle network
// This allows the contract to get real-world price data on-chain

// Why is this a library and not abstract?
// - Libraries are reusable code that can be attached to types (like uint256)
// - They can't have state variables or receive ETH
// - They're more gas efficient for utility functions since code is deployed once and reused

// Why not an interface?
// - Interfaces only declare function signatures without implementations
// - This code needs to implement the actual conversion logic, not just define it

library PriceConverter {
    // A library for converting between ETH and USD values
    
    // We could make this public, but then we'd have to deploy it
    // Internal functions are included in the contract that uses the library
    // Public functions would require deploying this as a separate contract
    function getPrice() internal view returns (uint256) {
        // Gets the current ETH/USD price from Chainlink oracle
        // 'internal' means it's only callable from within this contract or contracts that use this library
        // 'view' means it only reads blockchain data, doesn't modify state
        
        // Sepolia ETH / USD Address
        // https://docs.chain.link/data-feeds/price-feeds/addresses
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        );
        // Creates an interface to the Chainlink price feed at this specific address
        // This address is for the ETH/USD price feed on Sepolia testnet
        
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // Calls the oracle to get the latest price data
        // latestRoundData() returns multiple values (roundId, answer, startedAt, updatedAt, answeredInRound)
        // We only care about 'answer' (the price), so we ignore other values with the commas
        
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
        // Chainlink price feeds return prices with 8 decimals, but we want 18 decimals
        // So we multiply by 10^10 (10000000000) to add 10 more decimal places
        // Also converts from int256 to uint256 since prices shouldn't be negative
    }

    // 1000000000
    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        // Converts a given amount of ETH to its USD equivalent
        // This is the function that will be attached to uint256 in the main contract
        
        uint256 ethPrice = getPrice();
        // First gets the current ETH price in USD (with 18 decimals)
        
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // Calculates the USD value by multiplying ETH amount by the price
        // Then divides by 10^18 (1000000000000000000) to account for both values having 18 decimals
        // This gives the correct USD value with 18 decimals
        
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
        // Returns the USD value with 18 decimal places
    }
}
