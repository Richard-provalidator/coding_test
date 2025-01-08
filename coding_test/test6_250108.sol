/*
안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
안건들을 모아놓은 자료구조도 구현하세요. 

사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

* 사용자 등록 기능 - 사용자를 등록하는 기능
* 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
* 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
* 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
* 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
-------------------------------------------------------------------------------------------------
* 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract test6 {
    struct proposal {
        uint id;
        string title;
        string description;
        address proposer;
        uint yes;
        uint no;
        uint height;
        Status status;
    }

    enum Status {
        Voting,
        Passed,
        Rejected
    }

    struct user {
        string name;
        address addr;
        uint[] proposedProposals;
        mapping (uint => bool) proposalVoted;
    }

    proposal[] proposals;
    mapping (address => user) users;
    address[] userCounter;

    uint public idCounter;

    modifier isUserSet() {
        require(users[msg.sender].addr == msg.sender, "User not registered");
        _;
    }

    // 사용자 등록 기능 - 사용자를 등록하는 기능
    function setUser(string calldata name) public {
        users[msg.sender].name = name;
        users[msg.sender].addr = msg.sender;
        userCounter.push(msg.sender);
    }

    // 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    function propose(string calldata title, string calldata description) public isUserSet() {
        proposals[idCounter] = proposal(idCounter, title, description, msg.sender, 0, 0, block.number, Status.Voting);
        
        users[msg.sender].proposedProposals.push(idCounter);
        idCounter++;
    }

    function getProposedProposal() public view {

    }

    function getProposals() public view returns (proposal[] memory) {
        return proposals;
    }

    // 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    function vote(string calldata title, bool voting) public isUserSet() {
        uint id = findProposal(title);
        require(!users[msg.sender].proposalVoted[id], "You already voted this proposal");
        require(proposals[id].status == Status.Voting, "Proposal voting time ended");
        
        if (voting) proposals[id].yes++;
        else proposals[id].no++;
        
        users[msg.sender].proposalVoted[id] = true;
        updateStatus(id);
    }

    function findProposal(string calldata title) internal view returns (uint) {
        for (uint i = 0; i < idCounter; i++) {
            if (keccak256(bytes(proposals[i].title)) == keccak256(bytes(title))) {
                return proposals[i].id;
            }
        }
        revert("Proposal not found");
    }

    function updateStatus(uint id) internal {
        proposal memory p = proposals[id];

        if (block.number >= p.height + 15) {
            uint totalVotes = p.yes + p.no;
            uint totalUsers = userCounter.length;
            if (totalVotes >= totalUsers * 70 / 100) {
                if (p.yes >= totalVotes * 66 / 100) {
                    proposals[id].status = Status.Passed;
                } else {
                    proposals[id].status = Status.Rejected;
                }
            } else {
                proposals[id].status = Status.Rejected;
            }
        }
    }
}
