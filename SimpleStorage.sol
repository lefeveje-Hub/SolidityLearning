// SPDX-License-Identifier: MIT
// This line specifies the license for this code - MIT is a permissive open source license

pragma solidity ^0.8.19;
// This line specifies which Solidity version to use
// Note: The current syntax doesn't use ^ which means "exactly version 0.8.19" 
// If you want compatibility with future versions, you could use: pragma solidity ^0.8.19;

/**
 * @title SimpleStorage
 * @dev A basic contract to store a favorite number and a list of people with their favorite numbers
 */
contract SimpleStorage {
    // State variable to store a single number
    uint256 myFavoriteNumber;

    // Define a custom data structure (similar to a class) to store a person's information
    struct Person {
        uint256 favoriteNumber;  // A person's favorite number
        string name;             // A person's name
    }
    
    // Array to store multiple Person structures
    Person[] public listOfPeople;

    // Mapping to quickly look up a person's favorite number by their name
    // Works like a dictionary/hash map: name -> favoriteNumber
    mapping(string => uint256) public nameToFavoriteNumber;

    /**
     * @dev Store a new favorite number
     * @param _favoriteNumber The number to store
     * 
     * Note: The "virtual" keyword allows this function to be overridden in child contracts
     */
    function store(uint256 _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }

    /**
     * @dev Retrieve the stored favorite number
     * @return The current favorite number
     * 
     * Note: "view" means this function only reads data but doesn't modify state
     */
    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    /**
     * @dev Add a new person with their name and favorite number
     * @param _name The person's name (stored in memory temporarily)
     * @param _favoriteNumber The person's favorite number
     */
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // Add the new person to our array
        listOfPeople.push(Person(_favoriteNumber, _name));
        
        // Also store in the mapping for quick lookups
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
