// SPDX-License-Identifier: MIT
// This line specifies the license for the code - MIT is a popular open source license

pragma solidity ^0.8.14;
// Specifies the Solidity compiler version to use - must be at least 0.8.14 but less than 0.9.0

contract FallbackExample {
    // A simple contract demonstrating how receive() and fallback() functions work
    
    uint256 public result;
    // A state variable that will be set to different values
    // to demonstrate which function was triggered
    
    receive() external payable { 
        // Special function that is triggered when ETH is sent to the contract 
        // with an empty calldata (i.e., a simple ETH transfer with no data)
        // External means it can only be called from outside the contract
        // Payable means it can receive ETH
        
        result = 1;
        // Sets result to 1 to indicate the receive() function was called
    }

    fallback() external payable {
        // Special function that is triggered in two cases:
        // 1. ETH is sent with non-empty calldata that doesn't match any function signature
        // 2. No receive() function exists and ETH is sent with empty calldata
        // External means it can only be called from outside the contract
        // Payable means it can receive ETH
        
        result = 2;  
        // Sets result to 2 to indicate the fallback() function was called
    }
}
