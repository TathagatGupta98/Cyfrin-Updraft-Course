//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";


contract BasicNftTest is Test {

    DeployBasicNft public deployer;
    BasicNft public basicNft;  
    address public USER = makeAddr("user");
    

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrrect() public {
        assertEq(basicNft.name(),"Felines");
    }
    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mintNft("ipfs://QmXghDAffeN14yuXyLDqjoHpVxMothQCTC6QNLSgiYGXBM");
    }
}
