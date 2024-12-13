// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract SimpleStorage {
    uint256 myFavoriteNumber; // init to 0 (default)

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public listOfPeople; // []
    mapping(string => uint256) public nameToFavorite;

    // Person public pat = Person({
    //     favoriteNumber: 7,
    //     name: "Pat"
    // });

    function store(uint _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }

    function retrive() public view returns (uint256) {
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPeople.push( Person(_favoriteNumber, _name) );
        nameToFavorite[_name] = _favoriteNumber;
    }
}