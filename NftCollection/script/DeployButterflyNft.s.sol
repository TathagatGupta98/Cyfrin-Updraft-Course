// SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {ButterflyNft} from "../src/ButterflyNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployButterflyNft is Script {
    function run() external returns (ButterflyNft) {
        string memory butterflySvg = vm.readFile("../images/butterfly.svg");
        string memory caterpillarSvg = vm.readFile("../images/caterpillar.svg");

        vm.startBroadcast();
        ButterflyNft butterflyNft = new ButterflyNft(svgToImageURI(butterflySvg), svgToImageURI(caterpillarSvg));
        vm.stopBroadcast();
    
        return butterflyNft;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory){
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(bytes(svg));
    
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }


}

