//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
import "forge-std/console.sol";

/*
There is a prize (NFT or some object with the owner property) which is being auctioned. 
At block n, the auction is started by the deployer of the contract. 
Several players compete with each other by submitting bids. 
If player i submits a bid which is more than bids of other players, then player i has the highest bid.
If player i has the highest bids at some block and there is no other higher bids for 
three consecutive blocks then player i is the winner of the auction. In this case, the deployer of the contract sends the prize to the winner.
No bids are accepted if a previous bid is >3 blocks back in history
If no bids are submitted, then the prize stays with the deployer of the contract.
*/

contract EnglishAuction {
    address NFT;
    uint256 nftId;
    address owner;

    // Number of blocks before the auction expires
    uint8 constant expiry = 3;

    struct Bid {
        address bidder;
        uint256 amount;
        uint256 blockNumber;
    }

    Bid public highestBid;

    constructor(address _NFT, address _owner, uint256 _nftId) public {
        owner = _owner;
        NFT = _NFT;
        IERC721(NFT).transferFrom(owner, address(this), _nftId);
        highestBid = Bid(owner, 0, type(uint256).max - expiry);
    }

    function bid() external payable {
        require(msg.value > highestBid.amount, "Bid too Low");
        require(
            block.number < highestBid.blockNumber + expiry,
            "Auction has Ended"
        );

        payable(highestBid.bidder).send(highestBid.amount);

        highestBid = Bid(msg.sender, msg.value, block.number);
    }

    function endAuction() external {
        require(
            block.number > highestBid.blockNumber + expiry,
            "Auction hasn't Ended"
        );
        require(msg.sender == owner);

        IERC721(NFT).transferFrom(address(this), highestBid.bidder, nftId);
        (bool sent, bytes memory data) = msg.sender.call{
            value: highestBid.amount
        }("");
        require(sent, "Failed to send Ether");
    }
}

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
}
