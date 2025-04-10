// SPDX-License-Identifier: MIT
// This line specifies the license for the code - MIT is a popular open source license

pragma solidity ^0.8.18;
// Specifies the Solidity compiler version to use - must be at least 0.8.18 but less than 0.9.0

import {PriceConverter} from "./PriceConverter.sol";
// Imports the PriceConverter library from a separate file to handle ETH/USD conversion


contract FundMe {
    // Main contract definition starts here
    
    using PriceConverter for uint256;
    // This attaches the PriceConverter library functions to uint256 type
    // Allows calling library functions as methods on uint256 variables

    uint256 public minimumUsd = 5 *1e18;
    // Minimum amount required to fund in USD (with 18 decimal places)
    // 1e18 means 10^18, so this equals 5 USD with 18 decimal places of precision

    address[] public funders; 
    // An array that stores addresses of all people who have funded the contract
    // This allows tracking everyone who has sent funds
    
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    // A mapping (like a dictionary/hash table) that tracks how much each address has funded
    // Maps from: address of funder -> to: amount they've contributed in wei

    address public owner;
    // Stores the address of the contract owner (who can withdraw funds)

    constructor() {
        // Constructor runs once when the contract is deployed
        owner = msg.sender;
        // Sets the owner to whoever deploys the contract (msg.sender = address calling the function)
    }

    function fund() public payable {
        // Function to accept funds from users
        // 'payable' keyword means this function can receive ETH
        
        require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH");
        // Checks if the sent ETH (converted to USD) meets minimum requirement
        // msg.value is the amount of ETH sent with the transaction
        // getConversionRate() converts ETH to USD equivalent (from PriceConverter library)
        // If requirement fails, transaction reverts with error message
        
        funders.push(msg.sender);
        // Adds the sender's address to our list of funders
        
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
        // Updates the amount funded by this address by adding the new contribution
    }

    function withdraw() public onlyOwner {
        // Function to withdraw all funds from the contract
        // Has onlyOwner modifier so only the contract owner can call it
        
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            // Loop through all addresses in the funders array
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
            // Reset each funder's contributed amount to zero
        }
        
        funders = new address[](0);
        // Reset the funders array to a new empty array with 0 elements
        
        // Below are three different ways to send ETH - only the last one is active
        
        // 1. transfer method (commented out) - has 2300 gas limit, throws error on failure
        // payable(msg.sender).transfer(address(this).balance);
        
        // 2. send method (commented out) - has 2300 gas limit, returns boolean success/failure
        // bool sendSuccess = payable(msg.sender).send(address(this).balance); 
        // require (sendSuccess, "failed to send");
        
        // 3. call method (active) - forwards all available gas, returns success boolean and data
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        // Sends all contract balance to the owner (msg.sender)
        // The empty "" means no specific function is called on the receiving address
        // The second return value (data) is ignored with the ,)
        
        require(callSuccess, "failed to transfer value to fund");
        // If the call fails, revert the transaction with error message
    }

    modifier onlyOwner () {
        // Custom function modifier that can be applied to functions
        // Used to restrict function access to only the contract owner
        
        require(owner == msg.sender, "sender is not owner");
        // Checks if caller is the owner, reverts with message if not
        
        _;
        // The underscore represents where the modified function's code executes
        // Code before _ runs first, then the function, then any code after _
    }
    
    receive() external payable {
        // Special function that runs when ETH is sent to contract without data
        // External means it can only be called from outside the contract
        
        fund();
        // Calls the fund function to properly process the received ETH
    }

    fallback() external payable {
        // Special function that runs when ETH is sent with data that doesn't match any function
        // Or when no receive function exists and ETH is sent without data
        
        fund();
        // Calls the fund function to properly process the received ETH
    }
}
