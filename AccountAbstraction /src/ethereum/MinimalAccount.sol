/ SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAccount} from "lib/account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {MessageHashUtils} from "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

// The flow for ERC-4337 typically involves an EntryPoint contract deployed on the blockchain that acts as a central hub for processing user operations. Users create and sign UserOperation objects, which are then sent to the EntryPoint contract. The EntryPoint contract validates the UserOperation, checks the user's account balance, and executes the operation if everything is in order.
//This is a simple application of an account that implement all of this Account Abstraction stuff.
contract MinimalAccount is IAccount, Ownable {
    bytes32 constant SIG_VALIDATION_SUCCESS = bytes32(0);
    bytes32 constant SIG_VALIDATION_FAILED = bytes32(uint256(1));
    IEntryPoint public immutable i_entryPoint;

    constructor(address entryPoint) Ownable(msg.sender) {
        i_entryPoint = IEntryPoint(entryPoint);
    }

    modifier onlyEntryPoint() {
        require(msg.sender == address(i_entryPoint), "Only EntryPoint can call");
        _;
    }

    modifier onlyOwnerOrEntryPoint() {
        require(msg.sender == owner() || msg.sender == address(i_entryPoint), "Only owner or EntryPoint can call");
        _;
    }


    function validateUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 missingAccountFunds
    ) external override returns (uint256 validationData) {
        _payPrefund(missingAccountFunds);
        _validateSignature(userOp, userOpHash);
    }

    function execute (address target, uint256 value, bytes calldata data) external onlyOwnerOrEntryPoint {
        (bool success, bytes memory result) = target.call{value: value}(data);
        require(success, string(result));
    }

    function _validateSignature(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash
    ) internal onlyEntryPoint returns (bytes32) {
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(
            userOpHash
        );
        address signer = ECDSA.recover(ethSignedMessageHash, userOp.signature);

        if (signer == address(0) || signer != owner()) {
            return SIG_VALIDATION_FAILED; // Returns 1
        }

        return SIG_VALIDATION_SUCCESS; // Returns 0
    }
    function _payPrefund(uint256 mAf) internal{
        (bool success, ) = msg.sender.call{value: mAf, gas: type(uint256).max}("");
        require(success, "Failed to send prefund");
    }
}