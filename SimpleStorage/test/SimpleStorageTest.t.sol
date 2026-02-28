// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {DeploySimpleStorage} from "../script/DeploySimpleStorage.s.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";
import {Test} from "forge-std/Test.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public simpleStorage;

    function setUp() public {
        DeploySimpleStorage deployer = new DeploySimpleStorage();
        simpleStorage = deployer.run();
    }

    function testStoreNumber() public {
        uint256 expected = 123;
        simpleStorage.store(expected);
        uint256 actual = simpleStorage.retrieve();
        assertEq(actual, expected);
    }

    function testCreatePerson() public {
        string memory name = "Jon";
        uint256 expectedNumber = 25;
        simpleStorage.addPerson(name, expectedNumber);
        uint256 retrievedNumber = simpleStorage.nameToFavoriteNumber(name);
        assertEq(retrievedNumber, expectedNumber);
    }
}
