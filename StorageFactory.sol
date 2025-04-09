// SPDX-License-Identifier: MIT
// This line specifies the license for this code - MIT is a permissive open source license

pragma solidity ^0.8.19;
// This line specifies which Solidity version to use
// The ^ symbol means "this version or any compatible newer version"

// Import the SimpleStorage contract from another file
import {SimpleStorage} from "./SimpleStorage.sol";

/**
 * @title StorageFactory
 * @dev A factory contract that can create and interact with multiple SimpleStorage contracts
 */
contract StorageFactory {
    // Array to keep track of all SimpleStorage contracts we create
    SimpleStorage[] public listOfSimpleStorageContracts;

    /**
     * @dev Creates a new SimpleStorage contract and stores its reference
     */
    function createSimpleStorageContract() public {
        // Create a new instance of the SimpleStorage contract
        SimpleStorage simpleStorageContractVariable = new SimpleStorage();
        
        // Store the reference to the newly created contract in our array
        listOfSimpleStorageContracts.push(simpleStorageContractVariable);
    }

    /**
     * @dev Call the store function on a specific SimpleStorage contract
     * @param _simpleStorageIndex The index of the SimpleStorage contract in our array
     * @param _simpleStorageNumber The number to store in that contract
     */
    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _simpleStorageNumber
    ) public {
        // Important: This function lets us interact with previously deployed contracts
        
        // We get the contract at the given index and call its store function
        listOfSimpleStorageContracts[_simpleStorageIndex].store(
            _simpleStorageNumber
        );
        
        // Note: There's another way to do this using explicit address casting (shown in commented code)
        // SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    /**
     * @dev Call the retrieve function on a specific SimpleStorage contract
     * @param _simpleStorageIndex The index of the SimpleStorage contract in our array
     * @return The favorite number stored in the specified SimpleStorage contract
     */
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        // Get the value from the specified contract by calling its retrieve function
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
        
        // Note: There's another way to do this using explicit address casting (shown in commented code)
        // return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }
}
