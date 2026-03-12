// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {ButterflyNft} from "../src/ButterflyNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";


contract ButterflyNftTest is Test {

    ButterflyNft butterflyNft;
    string public constant ButterflyNft_svg_uri= "data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDMwMCAzMDAiIHdpZHRoPSIzMDAiIGhlaWdodD0iMzAwIj4KICA8ZGVmcz4KICAgIDxsaW5lYXJHcmFkaWVudCBpZD0id2luZ0dyYWQiIHgxPSIwJSIgeTE9IjAlIiB4Mj0iMTAwJSIgeTI9IjEwMCUiPgogICAgICA8c3RvcCBvZmZzZXQ9IjAlIiBzdHlsZT0ic3RvcC1jb2xvcjojZmZjYzAwO3N0b3Atb3BhY2l0eToxIiAvPgogICAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0eWxlPSJzdG9wLWNvbG9yOiNmZjY2MDA7c3RvcC1vcGFjaXR5OjEiIC8+CiAgICA8L2xpbmVhckdyYWRpZW50PgogICAgPGxpbmVhckdyYWRpZW50IGlkPSJib2R5R3JhZCIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgICA8c3RvcCBvZmZzZXQ9IjAlIiBzdHlsZT0ic3RvcC1jb2xvcjojNzdkZDc3O3N0b3Atb3BhY2l0eToxIiAvPgogICAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0eWxlPSJzdG9wLWNvbG9yOiM0NGFhNDQ7c3RvcC1vcGFjaXR5OjEiIC8+CiAgICA8L2xpbmVhckdyYWRpZW50PgogIDwvZGVmcz4KCiAgPGcgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTUwLCAxNTApIj4KICAgIDxnIGZpbGw9InVybCgjd2luZ0dyYWQpIiBzdHJva2U9IiNjYzU1MDAiIHN0cm9rZS13aWR0aD0iMyI+CiAgICAgICAgPHBhdGggZD0iTSAxMCAtMjUgQyA1MCAtODUsIDEzMCAtOTUsIDE0MCAtNDUgQyAxNTAgNSwgMTAwIDU1LCAxNSAyNSBaIiAvPgogICAgICAgIDxwYXRoIGQ9Ik0gLTEwIC0yNSBDIC01MCAtODUsIC0xMzAgLTk1LCAtMTQwIC00NSBDIC0xNTAgNSwgLTEwMCA1NSwgLTE1IDI1IFoiIC8+CiAgICAgICAgCiAgICAgICAgPHBhdGggZD0iTSAxNSAzNSBDIDYwIDc1LCAxMDAgMTE1LCA3MCAxMjUgQyA0MCAxMzUsIDIwIDEwNSwgMTAgNzUgWiIgLz4KICAgICAgICA8cGF0aCBkPSJNIC0xNSAzNSBDIC02MCA3NSwgLTEwMCAxMTUsIC03MCAxMjUgQyAtNDAgMTM1LCAtMjAgMTA1LCAtMTAgNzUgWiIgLz4KICAgIDwvZz4KCiAgICA8ZyBmaWxsPSIjZmZlZGEwIiBvcGFjaXR5PSIwLjciPgogICAgICAgIDxjaXJjbGUgY3g9IjgwIiBjeT0iLTM1IiByPSIxNSIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSItODAiIGN5PSItMzUiIHI9IjE1IiAvPgogICAgICAgIDxjaXJjbGUgY3g9IjUwIiBjeT0iODUiIHI9IjEwIiAvPgogICAgICAgIDxjaXJjbGUgY3g9Ii01MCIgY3k9Ijg1IiByPSIxMCIgLz4KICAgIDwvZz4KCiAgICA8ZyBmaWxsPSJ1cmwoI2JvZHlHcmFkKSIgc3Ryb2tlPSIjMzM4ODMzIiBzdHJva2Utd2lkdGg9IjIiPgogICAgICAgIDxlbGxpcHNlIGN4PSIwIiBjeT0iNSIgcng9IjE0IiByeT0iMTYiIC8+CiAgICAgICAgPGVsbGlwc2UgY3g9IjAiIGN5PSIzMCIgcng9IjEyIiByeT0iMTUiIC8+CiAgICAgICAgPGVsbGlwc2UgY3g9IjAiIGN5PSI1MyIgcng9IjEwIiByeT0iMTMiIC8+CiAgICAgICAgPGVsbGlwc2UgY3g9IjAiIGN5PSI3MyIgcng9IjgiIHJ5PSIxMSIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIwIiBjeT0iLTI1IiByPSIyNCIgLz4KICAgIDwvZz4KCiAgICA8Zz4KICAgICAgICA8Y2lyY2xlIGN4PSItOCIgY3k9Ii0zMCIgcj0iNiIgZmlsbD0id2hpdGUiIC8+CiAgICAgICAgPGNpcmNsZSBjeD0iLTgiIGN5PSItMzAiIHI9IjIuNSIgZmlsbD0iYmxhY2siIC8+CiAgICAgICAgPGNpcmNsZSBjeD0iOCIgY3k9Ii0zMCIgcj0iNiIgZmlsbD0id2hpdGUiIC8+CiAgICAgICAgPGNpcmNsZSBjeD0iOCIgY3k9Ii0zMCIgcj0iMi41IiBmaWxsPSJibGFjayIgLz4KICAgICAgICAKICAgICAgICA8cGF0aCBkPSJNIC0xMCAtMTUgUSAwIC01IDEwIC0xNSIgc3Ryb2tlPSIjMzM4ODMzIiBzdHJva2Utd2lkdGg9IjMiIGZpbGw9Im5vbmUiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIvPgogICAgPC9nPgoKICAgIDxnIHN0cm9rZT0iIzMzODgzMyIgc3Ryb2tlLXdpZHRoPSIzIiBmaWxsPSJub25lIj4KICAgICAgICA8cGF0aCBkPSJNIDEwIC00NSBDIDIwIC03MCwgMzAgLTgwLCA0NSAtODUiIC8+CiAgICAgICAgPGNpcmNsZSBjeD0iNDUiIGN5PSItODUiIHI9IjUiIGZpbGw9IiMzMzg4MzMiIHN0cm9rZT0ibm9uZSIvPgogICAgICAgIAogICAgICAgIDxwYXRoIGQ9Ik0gLTEwIC00NSBDIC0yMCAtNzAsIC0zMCAtODAsIC00NSAtODUiIC8+CiAgICAgICAgPGNpcmNsZSBjeD0iLTQ1IiBjeT0iLTg1IiByPSI1IiBmaWxsPSIjMzM4ODMzIiBzdHJva2U9Im5vbmUiLz4KICAgIDwvZz4KICA8L2c+Cjwvc3ZnPg==";
    string public constant CaterpillarNft_svg_uri= "data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDMwMCAxNTAiIHdpZHRoPSIzMDAiIGhlaWdodD0iMTUwIj4KICA8ZGVmcz4KICAgIDxsaW5lYXJHcmFkaWVudCBpZD0iYm9keUdyYWQiIHgxPSIwJSIgeTE9IjAlIiB4Mj0iMCUiIHkyPSIxMDAlIj4KICAgICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3R5bGU9InN0b3AtY29sb3I6Izc3ZGQ3NztzdG9wLW9wYWNpdHk6MSIgLz4KICAgICAgPHN0b3Agb2Zmc2V0PSIxMDAlIiBzdHlsZT0ic3RvcC1jb2xvcjojNDRhYTQ0O3N0b3Atb3BhY2l0eToxIiAvPgogICAgPC9saW5lYXJHcmFkaWVudD4KICA8L2RlZnM+CgogIDxnIHRyYW5zZm9ybT0idHJhbnNsYXRlKDIwLCAyMCkiPgogICAgPGcgZmlsbD0iIzQ0YWE0NCI+CiAgICAgICAgPGVsbGlwc2UgY3g9IjQwIiBjeT0iMTAwIiByeD0iOCIgcnk9IjUiIC8+CiAgICAgICAgPGVsbGlwc2UgY3g9IjcwIiBjeT0iMTA1IiByeD0iOCIgcnk9IjUiIC8+CiAgICAgICAgPGVsbGlwc2UgY3g9IjEwMCIgY3k9IjEwNSIgcng9IjgiIHJ5PSI1IiAvPgogICAgICAgIDxlbGxpcHNlIGN4PSIxMzAiIGN5PSIxMDUiIHJ4PSI4IiByeT0iNSIgLz4KICAgICAgICA8ZWxsaXBzZSBjeD0iMTYwIiBjeT0iMTA1IiByeD0iOCIgcnk9IjUiIC8+CiAgICAgICAgPGVsbGlwc2UgY3g9IjE5MCIgY3k9IjEwMCIgcng9IjgiIHJ5PSI1IiAvPgogICAgPC9nPgoKICAgIDxnIGZpbGw9InVybCgjYm9keUdyYWQpIiBzdHJva2U9IiMzMzg4MzMiIHN0cm9rZS13aWR0aD0iMiI+CiAgICAgIDxjaXJjbGUgY3g9IjQwIiBjeT0iODAiIHI9IjIwIiAvPgogICAgICA8Y2lyY2xlIGN4PSI3MCIgY3k9Ijg1IiByPSIyMiIgLz4KICAgICAgPGNpcmNsZSBjeD0iMTA1IiBjeT0iODgiIHI9IjI0IiAvPgogICAgICA8Y2lyY2xlIGN4PSIxNDAiIGN5PSI4NSIgcj0iMjIiIC8+CiAgICAgIDxjaXJjbGUgY3g9IjE3NSIgY3k9IjgwIiByPSIyMCIgLz4KICAgIDwvZz4KCiAgICA8Y2lyY2xlIGN4PSIyMTAiIGN5PSI3MCIgcj0iMjgiIGZpbGw9InVybCgjYm9keUdyYWQpIiBzdHJva2U9IiMzMzg4MzMiIHN0cm9rZS13aWR0aD0iMiIgLz4KCiAgICA8Zz4KICAgICAgPGNpcmNsZSBjeD0iMjAwIiBjeT0iNjUiIHI9IjUiIGZpbGw9IndoaXRlIiAvPgogICAgICA8Y2lyY2xlIGN4PSIyMDAiIGN5PSI2NSIgcj0iMiIgZmlsbD0iYmxhY2siIC8+CiAgICAgIDxjaXJjbGUgY3g9IjIyMCIgY3k9IjY1IiByPSI1IiBmaWxsPSJ3aGl0ZSIgLz4KICAgICAgPGNpcmNsZSBjeD0iMjIwIiBjeT0iNjUiIHI9IjIiIGZpbGw9ImJsYWNrIiAvPgogICAgICAKICAgICAgPHBhdGggZD0iTSAyMDUgODAgUSAyMTAgODUgMjE1IDgwIiBzdHJva2U9IiMzMzg4MzMiIHN0cm9rZS13aWR0aD0iMyIgZmlsbD0ibm9uZSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIi8+CgogICAgICA8cGF0aCBkPSJNIDIwMCA1MCBDIDE5NSAzMCAxOTAgMzAgMTg1IDQwIiBzdHJva2U9IiMzMzg4MzMiIHN0cm9rZS13aWR0aD0iMyIgZmlsbD0ibm9uZSIgLz4KICAgICAgPGNpcmNsZSBjeD0iMTg1IiBjeT0iNDAiIHI9IjQiIGZpbGw9IiMzMzg4MzMiIC8+CiAgICAgIDxwYXRoIGQ9Ik0gMjIwIDUwIEMgMjI1IDMwIDIzMCAzMCAyMzUgNDAiIHN0cm9rZT0iIzMzODgzMyIgc3Ryb2tlLXdpZHRoPSIzIiBmaWxsPSJub25lIiAvPgogICAgICA8Y2lyY2xlIGN4PSIyMzUiIGN5PSI0MCIgcj0iNCIgZmlsbD0iIzMzODgzMyIgLz4KICAgIDwvZz4KICA8L2c+Cjwvc3ZnPg==";

    address USER = makeAddr("USER");

    function setUp() public {
        butterflyNft = new ButterflyNft(CaterpillarNft_svg_uri, ButterflyNft_svg_uri);
    }

    function testViewTokenURI() public {
        vm.prank(USER);
        butterflyNft.mintNft();
        console.log(butterflyNft.tokenURI(0));
    }

    function buildExpectedTokenURI(string memory imageURI) internal view returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(bytes(abi.encodePacked(
                    '{"name" : "', butterflyNft.name(),
                    '", "description" : "An NFT that can transform from a caterpillar to an adult butterfly.",',
                    ' "attributes" : [{"trait_type":"moodiness", "value": 100}],',
                    ' "image" : "', imageURI, '"}'
                )))
            )
        );
    }

    function testFlipFormIntegration() public {
        vm.prank(USER);
        butterflyNft.mintNft();  

        assertEq(
            butterflyNft.tokenURI(0),
            buildExpectedTokenURI(CaterpillarNft_svg_uri)
        );

        vm.prank(USER);
        butterflyNft.flipForm(0);  

        assertEq(
            butterflyNft.tokenURI(0),
            buildExpectedTokenURI(ButterflyNft_svg_uri)
        );
    }
}