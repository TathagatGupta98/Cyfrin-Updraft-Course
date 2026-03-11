//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script {

    function run () external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        MintNftOnContract(mostRecentlyDeployed);
    }

    function MintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft("ipfs://QmXghDAffeN14yuXyLDqjoHpVxMothQCTC6QNLSgiYGXBM");
        vm.stopBroadcast();
    }
}