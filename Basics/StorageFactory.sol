// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {

    SimpleStorage[] public listOfSimpleStorages;

    function createSimpleStorageContract() public {
        listOfSimpleStorages.push(new SimpleStorage());
    }

    function sfStore(uint256 _ssIndex, uint256 _storeNumber) public {
        SimpleStorage ss = listOfSimpleStorages[_ssIndex];
        ss.store(_storeNumber);
    }

    function sfGet(uint256 _ssIndex) public view returns(uint256) {
        SimpleStorage ss = listOfSimpleStorages[_ssIndex];
        return ss.retrive();
    }
}