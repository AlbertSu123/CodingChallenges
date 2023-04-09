// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.8.13;

import "../EnglishAuction.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract EnglishAuctionTest is Test {
    EnglishAuction cntrct;
    NFT nft;

    address public owner = mkaddr("owner");
    address public bidder1 = mkaddr("bidder1");
    address public bidder2 = mkaddr("bidder2");

    uint256 gasCosts = .1 ether;

    function setUp() public {
        vm.deal(owner, 10 ether);

        vm.startPrank(owner);
        cntrct = new EnglishAuction(address(0), owner, 0);

        nft = new NFT();
        vm.stopPrank();
        vm.deal(bidder1, 10 ether);
        vm.deal(bidder2, 10 ether);
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }

    function testE2E() public {
        vm.startPrank(bidder1);
        cntrct.bid{value: 1 ether}();
        checkBalances(1 ether, 9 ether, 10 ether);
        vm.stopPrank();

        vm.startPrank(bidder2);
        cntrct.bid{value: 2 ether}();
        checkBalances(2 ether, 10 ether, 8 ether);
        vm.stopPrank();

        vm.roll(block.number + 2);

        vm.startPrank(bidder1);
        cntrct.bid{value: 3 ether}();
        checkBalances(3 ether, 7 ether, 10 ether);
        vm.stopPrank();

        vm.roll(block.number + 4);

        vm.startPrank(bidder2);
        vm.expectRevert();
        cntrct.bid{value: 4 ether}();
        checkBalances(3 ether, 7 ether, 10 ether);
        vm.stopPrank();

        vm.startPrank(owner);
        cntrct.endAuction();
        checkBalances(0 ether, 7 ether, 10 ether);
        require(
            address(owner).balance == 3 ether,
            "Owner received incorrect amount"
        );
        vm.stopPrank();
    }

    function checkBalances(
        uint256 _contract,
        uint256 _bidder1,
        uint256 _bidder2
    ) public {
        require(
            address(cntrct).balance == _contract,
            "Incorrect Contract Balance"
        );
        require(
            address(bidder1).balance == _bidder1,
            "Incorrect bidder1 Balance"
        );

        require(
            address(bidder2).balance == _bidder2,
            "Incorrect bidder2 Balance"
        );
    }
}

import {ERC721} from "solmate/tokens/ERC721.sol";

contract NFT is ERC721 {
    string public baseURI;

    constructor() ERC721("hi", "hello") {}

    function mint() external {
        _mint(msg.sender, 1);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return "";
    }
}
