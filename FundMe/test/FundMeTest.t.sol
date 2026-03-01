//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {

    FundMe public fundMe;
    DeployFundMe public deployFundMe;

    address user = makeAddr("Tathagat");
 
    uint256 public constant SEND_VALUE = 1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() public {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(user, STARTING_BALANCE);

    }

    function testOwnerIsMsgSender() public view{
        address owner = fundMe.getOwner();
        assertEq(owner, msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWIthoutEnoughETH() public {
        vm.expectRevert(); 
        fundMe.fund();     // <- We send 0 value
    }

    function testFundUpdatesFundDataStructure() public {

        vm.startPrank(user);
        vm.deal(user, SEND_VALUE);

        fundMe.fund{value: SEND_VALUE }();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(user);
        assertEq(amountFunded, SEND_VALUE);

        vm.stopPrank();
    }
    function testAddsFunderToArrayOfFunders() public {
        vm.startPrank(user);
        fundMe.fund{value: SEND_VALUE}();
        vm.stopPrank();

        address funder = fundMe.getFunder(0);
        assertEq(funder, user);
    }
    function testOnlyOwnerCanWithdraw() public funded{
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawFromASingleFunder() public funded {
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.txGasPrice(GAS_PRICE);
        uint256 gasStart = gasleft();

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log("Withdraw consumed: %d gas", gasUsed);

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
    
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
    
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
    
        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
        assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
    }

    function testPrintStorageData() public{
        for(uint256 i =0; i<3;i++){
            bytes32 value = vm.load(address(fundMe), bytes32(i));
            console.log("Value at location", i, ":");
            console.logBytes32(value);
        }
        console.log("PriceFeed address:", address(fundMe.getPriceFeed()));
    }

    modifier funded() {
        vm.prank(user);
        fundMe.fund{value: SEND_VALUE}();
        assert(address(fundMe).balance > 0);
        _;
    }

}