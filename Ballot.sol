pragma solidity ^0.8.0;

contract Ballot {
    // Structure to hold proposal information
    struct Proposal {
        uint voteCount;
        string name;
    }

    // Array of proposals
    Proposal[] proposals;

    // Mapping to store voter addresses and their vote
    mapping(address => uint) voterToProposal;

    // Event for voting
    event Voted(address voter, uint proposal);

    // Function to submit a new proposal
    function submitProposal(string memory _name) public {
        proposals.push(Proposal({
            voteCount: 0,
            name: _name
        }));
    }

    // Function to vote for a proposal
    function vote(uint _proposal) public {
        // Ensure the voter hasn't already voted
        require(voterToProposal[msg.sender] == 0, "Already voted.");

        // Update vote count
        proposals[_proposal].voteCount++;

        // Store the voter's vote
        voterToProposal[msg.sender] = _proposal;

        // Emit the Voted event
        emit Voted(msg.sender, _proposal);
    }

    // Function to get the winner of the vote
    function winnerName() public view returns (string memory) {
        uint maxVotes = 0;
        uint winningProposal = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > maxVotes) {
                maxVotes = proposals[i].voteCount;
                winningProposal = i;
            }
        }
        return proposals[winningProposal].name;
    }
}
