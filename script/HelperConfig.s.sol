// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2Mock.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinatorV2;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackGasLimit;
    }

    NetworkConfig public activeNetworkConfig;

    uint96 public constant BASE_FEE = 0.25 ether;
    uint96 public constant GAS_PRICE_LINK = 1e9;

    constructor() {
        if (block.chainid == 31337) {
            activeNetworkConfig = createLocalNetworkConfig();
        }
    }

    function createLocalNetworkConfig() public returns (NetworkConfig memory){
        vm.startBroadcast();

        VRFCoordinatorV2Mock vrfCoordinator = new VRFCoordinatorV2Mock(BASE_FEE, GAS_PRICE_LINK);

        uint64 subscriptionId = vrfCoordinator.createSubscription();

        vrfCoordinator.fundSubscription(
            subscriptionId,
            10 ether
        );

        vm.stopBroadcast();

        NetworkConfig memory localConfig = NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinatorV2: address(vrfCoordinator),
            gasLane: bytes32(0),
            subscriptionId: subscriptionId,
            callbackGasLimit: 500000
        });

        return localConfig;
    }

    function getConfig() public view returns(NetworkConfig memory){
        return activeNetworkConfig;
    }
}