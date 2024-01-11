// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "ds-test/test.sol";
import "../src/VotingSystem.sol";

contract VotingSystemTest is DSTest {
    VotingSystem votingSystem;
    address owner;

    function setUp() public {
        owner = address(this);
        votingSystem = new VotingSystem();
    }

    function testAddCandidate() public {
        string memory candidateName = "Alice";
        bytes32 candidateNameBytes = keccak256(abi.encodePacked(candidateName));

        votingSystem.addCandidate(candidateNameBytes);
        (bytes32 name, uint voteCount) = votingSystem.candidates(0);

        assertEq(name, candidateNameBytes, "Candidate name should match the input.");
        assertEq(voteCount, 0, "Candidate vote count should be initialized to 0.");
    }

    function testRegisterVoter() public {
        address voter = address(0x1);
        votingSystem.registerVoter(voter);
        bool isRegistered = votingSystem.voters(voter).isRegistered;

        assertTrue(isRegistered, "Voter should be registered.");
    }

    function testVote() public {
        string memory candidateName = "Alice";
        bytes32 candidateNameBytes = keccak256(abi.encodePacked(candidateName));
        address voter = address(0x1);

        votingSystem.addCandidate(candidateNameBytes);
        votingSystem.registerVoter(voter);
        votingSystem.startVoting();
        votingSystem.vote(0);

        uint voteCount = votingSystem.candidates(0).voteCount;
        assertEq(voteCount, 1, "Candidate should have 1 vote.");
    }
}
