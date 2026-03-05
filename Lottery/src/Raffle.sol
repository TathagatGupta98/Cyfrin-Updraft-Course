// version
// imports
// errors
// interfaces, libraries, contract

// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions


/* -------------------------------------------------------------------------- */
/*                              Lottery Contract                              */
/* -------------------------------------------------------------------------- */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/* --------------------------------- IMPORTS -------------------------------- */

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/* --------------------------------- ERRORS --------------------------------- */
error Raffle_NotEnoughEthSent();


contract Raffle is VRFConsumerBaseV2Plus{

/* ---------------------------- TYPE DECLARATIONS --------------------------- */
enum RaffleState {
    OPEN,
    CALCULATING
}

/* ----------------------------- STATE VARIABLES ---------------------------- */

    // Lottery variables
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;
    RaffleState private s_raffleState;
    
    // Chainlink VRF variables
    uint256 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

/* --------------------------------- EVENTS --------------------------------- */
event EnteredRaffle(address indexed player);

/* -------------------------------------------------------------------------- */
/*                                  FUNCTIONS                                 */
/* -------------------------------------------------------------------------- */

/* ------------------------------ CONSTRUCTORS ------------------------------ */
    constructor(
        uint256 subscriptionId,
        bytes32 gasLane, // keyHash
        uint256 interval,
        uint256 entranceFee,
        uint32 callbackGasLimit,
        address vrfCoordinatorV2) 
    VRFConsumerBaseV2Plus(vrfCoordinatorV2){
        i_gasLane = gasLane;
        i_interval = interval;
        i_subscriptionId = subscriptionId;
        i_entranceFee = entranceFee;
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        i_callbackGasLimit = callbackGasLimit;
    }

/* -------------------------------- EXTERNAL -------------------------------- */
    function enterRaffle() external payable {
        if(msg.value < i_entranceFee) {
            revert Raffle_NotEnoughEthSent();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    function pickWinner() external {
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert();
        }

        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: i_gasLane,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );

    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override{}


/* ------------------------------ VIEW AND PURE ----------------------------- */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}