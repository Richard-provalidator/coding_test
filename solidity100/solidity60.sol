// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q51 {
    // 숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
    function q51(uint[] memory ns) public pure returns (uint[] memory res, uint m) {
        res = ns;
        for (uint i=0; i< ns.length; i++) {
            for (uint j=i; j< ns.length; j++) {
                if (ns[i] < ns[j]) {
                    uint temp = ns[i];
                    ns[i] = ns[j];
                    ns[j] = temp;
                }
            }
        }
        m = ns[2];
    }
}

contract Q52 {
    // 자동으로 아이디를 만들어주는 함수를 구현하세요. 이름, 생일, 지갑주소를 기반으로 만든 해시값의 첫 10바이트를 추출하여 아이디로 만드시오.
    function q52(string calldata name, uint birthday) public view returns (bytes10) {
        require(birthday > 10000000 && birthday <= 99999999, "Birthday must be this format YYYYMMDD, e.g. 20040403");
        return bytes10(keccak256(abi.encodePacked(name, birthday, msg.sender)));
    }
}

contract Q53 {
    // 시중에는 A,B,C,D,E 5개의 은행이 있습니다. 각 은행에 고객들은 마음대로 입금하고 인출할 수 있습니다. 각 은행에 예치된 금액 확인, 입금과 인출할 수 있는 기능을 구현하세요.
    // 힌트 : 이중 mapping을 꼭 이용하세요.
    string[5] banks = ["A", "B", "C", "D", "E"];
    mapping(string => mapping(address => uint)) balances;

    modifier bankCheck(string calldata bank) {
        bool checked;
        for (uint i=0; i<banks.length; i++) {
            if (keccak256(bytes(bank)) == keccak256(bytes(banks[i]))) {
                checked = true;
                break;
            }
        }
        require(checked, "Bank is only A, B, C, D, E");
        _;
    }

    function deposit(string calldata bank) public payable bankCheck(bank) {
        require(msg.value > 0, "amount must be more than 0");
        balances[bank][msg.sender] += msg.value;
    }

    function withdraw(string calldata bank, uint amount) public bankCheck(bank) {
        require(balances[bank][msg.sender] >= amount, "Insufficient balance");
        balances[bank][msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getBalance(string calldata bank) public view bankCheck(bank) returns (uint) {
        return balances[bank][msg.sender];
    }

}

contract Q54 {
    // 기부받는 플랫폼을 만드세요. 가장 많이 기부하는 사람을 나타내는 변수와 그 변수를 지속적으로 바꿔주는 함수를 만드세요.
    // 힌트 : 굳이 mapping을 만들 필요는 없습니다.
    address public top;
    uint public highest;

    function donate() public payable {
        require(msg.value > 0, "amount must be more than 0");

        if (msg.value > highest) {
            highest = msg.value;
            top = msg.sender;
        }
    }
}

contract Q55 {
    // 배포와 함께 owner를 설정하고 owner를 다른 주소로 바꾸는 것은 오직 owner 스스로만 할 수 있게 하십시오.
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function ownerChange(address addr) public {
        require(owner == msg.sender, "This is only owner function");
        owner = addr;
    }
}

contract Q56 {
    // 위 문제의 확장버전입니다. owner와 sub_owner를 설정하고 owner를 바꾸기 위해서는 둘의 동의가 모두 필요하게 구현하세요.
    address public owner;
    address public sub_owner;

    mapping(address => bool) approval;

    constructor(address addr) {
        require(msg.sender != addr, "Owner and sub_owner must be different");
        owner = msg.sender;
        sub_owner = addr;
    }

    function ownerChange(address addr) public {
        require(owner == msg.sender || sub_owner == msg.sender, "This is only owners function");

        if (approval[owner] && approval[sub_owner]) {
            owner = addr;
            approval[owner] = false;
            approval[sub_owner] = false;
        } else {
            revert("You need approval of owners");
        }
    }

    function setApproval() public {
        require(owner == msg.sender || sub_owner == msg.sender, "This is only owners function");
        approval[msg.sender] = true;
    }
}

contract Q57 {
    // 위 문제의 또다른 버전입니다. owner가 변경할 때는 바로 변경가능하게 sub-owner가 변경하려고 한다면 owner의 동의가 필요하게 구현하세요.
    address public owner;
    address public sub_owner;

    mapping(address => bool) approval;

    constructor(address addr) {
        require(msg.sender != addr, "Owner and sub_owner must be different");
        owner = msg.sender;
        sub_owner = addr;
    }

    function ownerChange(address addr) public {
        require(owner == msg.sender || sub_owner == msg.sender, "This is only owners function");
        require(sub_owner != addr, "Owner and sub_owner must be different");

        if (msg.sender != owner) {
            if (approval[owner]) {
                owner = addr;
                approval[owner] = false;
            } else {
                revert("You need approval of owner");
            }
        }
        owner = addr;
    }

    function setApproval() public {
        require(owner == msg.sender, "This is only owner function");
        approval[msg.sender] = true;
    }
}

contract Q58 {
    // A contract에 a,b,c라는 상태변수가 있습니다. a는 A 외부에서는 변화할 수 없게 하고 싶습니다. b는 상속받은 contract들만 변경시킬 수 있습니다. c는 제한이 없습니다. 각 변수들의 visibility를 설정하세요.
    uint private a;
    uint internal b;
    uint c;
}

contract Q59 {

    uint future;
    // 현재시간을 받고 2일 후의 시간을 설정하는 함수를 같이 구현하세요.
    function q59() public {
        future = block.timestamp + 2 days;
    }
}

contract Q60 {
    // 방이 2개 밖에 없는 펜션을 여러분이 운영합니다. 각 방마다 한번에 3명 이상 투숙객이 있을 수는 없습니다. 특정 날짜에 특정 방에 누가 투숙했는지 알려주는 자료구조와 그 자료구조로부터 값을 얻어오는 함수를 구현하세요.
    // struct room {
    //     mapping(uint => string[3]) records;
    // }
    // room[2] rooms;
    enum room {A, B}
    mapping(room =>mapping(uint => string[3])) records;

    modifier room_dateCheck(room roomNumber, uint date) {
        require(roomNumber == room.A || roomNumber == room.B, "Only 2 room we have, 0, 1");
        require(date > 10000000 && date <= 99999999, "Date must be this format YYYYMMDD, e.g. 20040403");
        _;
    }

    function setRoom(room roomNumber, uint date, string[3] memory guests) public room_dateCheck(roomNumber, date) {
        records[roomNumber][date] = guests;
    }

    function getRecord(room roomNumber, uint date) public view room_dateCheck(roomNumber, date) returns (string[3] memory guests) {
        guests = records[roomNumber][date];
    }
}
