pragma solidity ^0.8.0;

contract BlindAuction {
    // Variables
    uint public auctionEnd;
    uint public highestBid;
    address public highestBidder;
    uint public biddingEnd;
    mapping (address => uint) public bids;

    // Event for bid submission
    event NewBid(address bidder, uint bidAmount);

    // Function to register a bid
    function bid(uint bidAmount) public payable {
        require(msg.value == bidAmount, "Incorrect bid amount.");
        require(bidAmount > highestBid, "Bid amount must be higher than current highest bid.");
        require(bidAmount > 0, "Bid amount must be greater than zero.");
        require(now <= auctionEnd, "Auction has already ended.");

        // Store the bid
        highestBid = bidAmount;
        highestBidder = msg.sender;
        bids[msg.sender] = bidAmount;

        // Emit the NewBid event
        emit NewBid(msg.sender, bidAmount);
    }

    // Function to reveal the bid
    function reveal() public {
        require(now >= biddingEnd, "Bidding has not ended yet.");
        require(msg.sender == highestBidder, "You are not the highest bidder.");

        // Transfer the winnings
        msg.sender.transfer(highestBid);
    }

    // Constructor function to set the auction end time
    constructor(uint _auctionEnd) public {
        auctionEnd = _auctionEnd;
        biddingEnd = _auctionEnd + 1 days;
    }
}