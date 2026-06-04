// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Test} from "forge-std/Test.sol";
import {Lottery} from "../src/Lottery.sol";
import {DeployLottery} from "../script/DeployLottery.s.sol";

contract TestLottery is Test,Script{
    Lottery lottery;
    address PLAYER = makeAddr("player");
    uint256 constant STRATING_BALANCE = 10 ether;

    function setUp() public{
        DeployLottery deployer = new DeployLottery();
        lottery = deployer.run();
        vm.deal(PLAYER,STRATING_BALANCE);
    }

    function testLotteryStartsOpen() view public{
        assert(lottery.getLotteryState() == Lottery.LotteryState.OPEN);
    }

    function testRevertIfIncorrectFee() public{
        vm.prank(PLAYER);
        vm.expectRevert(Lottery.Lottery__IncorrectEntranceFee.selector);
        lottery.enterLottery();
    }

    function testPlayerRecorded() public{
        vm.startPrank(PLAYER);
        lottery.enterLottery{value:lottery.getEntranceFee()}();
        vm.stopPrank();
        assertEq(lottery.getPlayerUsingIndex(0),PLAYER);
    }

    function testLotteryStateDuringUpkeep() public {
        vm.prank(PLAYER);
        lottery.enterLottery{value: lottery.getEntranceFee()}();
        vm.warp(block.timestamp + lottery.getInterval() + 1);
        lottery.performUpkeep("");
        assertEq(uint256(lottery.getLotteryState()),1);
    }

    function testcheckUpkeepReturnsFalseIfNoPlayers() public {
        vm.warp(block.timestamp + lottery.getInterval() + 1);
        (bool upkeepNeeded, ) = lottery.checkUpkeep("");
        assertFalse(upkeepNeeded);
    }

    function testcheckUpkeepReturnsFalseIfTimeNotPasses() public{
        vm.prank(PLAYER);
        lottery.enterLottery{value: lottery.getEntranceFee()}();
        (bool upkeepNeeded, ) = lottery.checkUpkeep("");
        assertFalse(upkeepNeeded);
    }

    function testCheckUpkeepReturnsTrue() public{
        vm.prank(PLAYER);
        lottery.enterLottery{value: lottery.getEntranceFee()}();
        vm.warp(block.timestamp + lottery.getInterval() + 1);
        (bool upkeepNeeded, ) = lottery.checkUpkeep("");
        assertTrue(upkeepNeeded);
    }

    function testPerformUpkeepRevertsIfNotNeeded() public{
        vm.expectRevert(abi.encodeWithSelector(
            Lottery.Lottery__UpkeepNotNeeded.selector,0,0,0)
        );
        lottery.performUpkeep("");
    }

    function testPerformUpkeepChangesState() public{
        vm.prank(PLAYER);
        lottery.enterLottery{value: lottery.getEntranceFee()}();
        vm.warp(block.timestamp + lottery.getInterval() + 1);
        lottery.performUpkeep("");
        assert(lottery.getLotteryState() == Lottery.LotteryState.CALCULATING);
    }
}