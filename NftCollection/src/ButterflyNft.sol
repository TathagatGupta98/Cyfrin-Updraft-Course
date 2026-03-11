//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";


contract ButterflyNft  is ERC721{

    error FormNFT__CantFlipFormIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_caterpillarSvgImageUri;
    string private s_butterflySvgImageUri;

    enum Form {
        Caterpillar,
        Butterfly
    }

    mapping(uint256 => Form) private s_tokenIdToForm;

    constructor(string memory caterpillarSvgImageUri, string memory butterflySvgImageUri) ERC721("Butterfly NFT" , "BN"){

        s_tokenCounter = 0;
        s_caterpillarSvgImageUri = caterpillarSvgImageUri;
        s_butterflySvgImageUri = butterflySvgImageUri;
    }

    function mintNft () public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToForm[s_tokenCounter] = Form.Caterpillar;
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageURI;
        if(s_tokenIdToForm[tokenId] == Form.Caterpillar)
        {
            imageURI = s_caterpillarSvgImageUri;
        }
        else{
            imageURI = s_butterflySvgImageUri;
        }

        return string(  
            abi.encodePacked(   //concatenation 
                _baseURI(), //Add the extra part for browser to understand it's base64
                Base64.encode(  //base64 encryption 
                    bytes(  //converts string to bytes
                        abi.encodePacked(   //concatenates the string
                            '{"name" : "', 
                            name(),
                            '", "description" : "An NFT that can transform from a caterpillar to an adult butterfly.", "attributes" : [{"trait_type":"moodiness", "value": 100}], "image" : "',
                            imageURI, 
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function flipForm(uint256 tokenId) public view {
        if(getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender){
            revert FormNFT__CantFlipFormIfNotOwner();
        }
    
        if(s_tokenIdToForm[tokenId] == Form.Caterpillar){
            s_tokenIdToForm[tokenId] == Form.Butterfly;
        } else{
            s_tokenIdToForm[tokenId] == Form.Caterpillar;
        }
    }
}