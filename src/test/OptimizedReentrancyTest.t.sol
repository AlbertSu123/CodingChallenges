// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.6.11;

import "../OptimizedDaoEscrowFarm.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract ReentrancyTest is Test {
    OptimizedDaoEscrowFarm cntrct;

    address public exploiter = mkaddr("exploiter");

    function setUp() public {
        cntrct = new OptimizedDaoEscrowFarm();
        vm.deal(address(this), 10 ether);
        vm.deal(address(cntrct), 10 ether);
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.deal(addr, 10 ether);
        vm.label(addr, name);
        return addr;
    }

    function testOptimizedDaoEscrowFarm_1call() public {
        vm.startPrank(exploiter);
        address(cntrct).call{value: .5 ether}("");
    }

    function testOptimizedDaoEscrowFarm_2call() public {
        vm.startPrank(exploiter);
        address(cntrct).call{value: .5 ether}("");
        address(cntrct).call{value: .5 ether}("");
    }

    function testOptimizedDaoEscrowFarm_10call() public {
        vm.startPrank(exploiter);
        for (uint i = 0; i < 10; i++) {
            address(cntrct).call{value: .1 ether}("");
        }
    }
}
