// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Script} from "forge-std/Script.sol";
import {Lottery} from "../src/Lottery.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2Mock.sol";

contract DeployLottery is Script {
    function run() external returns (Lottery) {
        HelperConfig helperConfig = new HelperConfig();

        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        vm.startBroadcast();

        Lottery lottery = new Lottery(
            config.entranceFee,
            config.interval,
            config.vrfCoordinatorV2,
            config.gasLane,
            config.subscriptionId,
            config.callbackGasLimit
        );

        VRFCoordinatorV2Mock(config.vrfCoordinatorV2).addConsumer(
            config.subscriptionId,
            address(lottery)
        );
        vm.stopBroadcast();

        return lottery;
    }
}