// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;


contract NigeriaDecides {
    struct Nigerian {
        uint256 numOfTimesToVote;
        bool alreadyVoted;
        address someoneToVoteInYourStead; 
        uint256 vote; 
    }

    struct Proposal {
        bytes32 name;
        uint256 voteCount;
    }

    address public INEC;

    mapping(address => Nigerian) public voters;
    Proposal[] public proposals;
    constructor(bytes32[] memory proposalNames) {
        INEC = msg.sender;
        voters[INEC].numOfTimesToVote = 1; 
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }
    function givePVC(address voter) public {
        require(
            msg.sender == INEC,
            "Only INEC can give right to vote."
        );
        require(!voters[voter].alreadyVoted, "The voter already voted.");
        require(voters[voter].numOfTimesToVote == 0);
        voters[voter].numOfTimesToVote = 1;
    }
    function someoneToVoteInYourStead(address to) public {
      
        Nigerian storage sender = voters[msg.sender];
        require(!sender.alreadyVoted, "You already yVoted.");
        require(to != msg.sender, "Self-delegation is disallowed.");
        while (voters[to].someoneToVoteInYourStead != address(0)) {
            to = voters[to].someoneToVoteInYourStead;

            require(to != msg.sender, "Found loop in delegation.");
        }

        sender.alreadyVoted = true;
        sender.someoneToVoteInYourStead = to;
        Nigerian storage someoneToVoteInYourStead_ = voters[to];
        if (someoneToVoteInYourStead_.alreadyVoted) {
            proposals[someoneToVoteInYourStead_.vote].voteCount += sender.numOfTimesToVote;
        } else {
            someoneToVoteInYourStead_.numOfTimesToVote += sender.numOfTimesToVote;
        }
    }

    function vote(uint256 proposal) public {
        Nigerian storage sender = voters[msg.sender];
        require(sender.numOfTimesToVote != 0, "Has no right to vote");
        require(!sender.alreadyVoted, "Already alreadyVoted.");
        sender.alreadyVoted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.numOfTimesToVote;
    }

    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function getAllProposals() external view returns (Proposal[] memory) {
        Proposal[] memory items = new Proposal[](proposals.length);
        for (uint256 i = 0; i < proposals.length; i++) {
            items[i] = proposals[i];
        }
        return items;
    }

    function winnerName() public view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}