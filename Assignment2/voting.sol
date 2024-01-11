//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint vote;
    }

    struct Candidate {
        bytes32 name;
        uint voteCount;
    }

    address public owner;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    bool public votingStarted;

    event VoterRegistered(address voter);
    event CandidateAdded(bytes32 candidate);
    event Vote(address voter, bytes32 candidate);
    event VotingStarted();
    event VotingEnded();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerVoter(address _voter) public onlyOwner {
        require(!voters[_voter].isRegistered, "Voter is already registered.");
        voters[_voter].isRegistered = true;
        emit VoterRegistered(_voter);
    }

    function addCandidate(bytes32 _name) public onlyOwner {
        candidates.push(Candidate({
            name: _name,
            voteCount: 0
        }));
        emit CandidateAdded(_name);
    }

    function startVoting() public onlyOwner {
        require(!votingStarted, "Voting has already started.");
        votingStarted = true;
        emit VotingStarted();
    }

    function vote(uint _candidateIndex) public {
        require(voters[msg.sender].isRegistered, "You must be registered to vote.");
        require(!voters[msg.sender].hasVoted, "You have already voted.");
        require(votingStarted, "Voting is not started yet.");
        require(_candidateIndex < candidates.length, "Invalid candidate.");

        voters[msg.sender].vote = _candidateIndex;
        voters[msg.sender].hasVoted = true;
        candidates[_candidateIndex].voteCount += 1;

        emit Vote(msg.sender, candidates[_candidateIndex].name);
    }

    function endVoting() public onlyOwner {
        require(votingStarted, "Voting has not started yet.");
        votingStarted = false;
        emit VotingEnded();
    }

    function getResults() public view returns (Candidate[] memory) {
        require(!votingStarted, "Voting is still in progress.");
        return candidates;
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }
}
