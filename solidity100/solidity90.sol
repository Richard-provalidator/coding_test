// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q81 {
    // Contract에 예치, 인출할 수 있는 기능을 구현하세요. 
    // 지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요.
    mapping(address => uint) public balance;
    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }
    function withdraw() public {
        uint amount = balance[msg.sender];
        balance[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}

contract Q82 {
    // 특정 숫자를 입력했을 때 그 숫자까지의 3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
    function q82(uint n) public pure returns (uint count) {
        for (uint i=0; i<n; i++) {
            if(i%3==0 || i%5 == 0 || i%8 == 0) {
                count++;
            }
        }
    }
}

contract Q83 {
    // 이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 mapping을 가진 구조체 사람을 구현하세요. 
    // 사람이 들어가는 array를 구현하고 array안에 push 하는 함수를 구현하세요.
    struct man {
        string name;
        uint id;
        address addr;
        uint key;
        mapping(uint => string) map;
    }
    mapping(uint => string) map2;
    man[] public array;

    function q83(string calldata name, uint id, address addr, uint key, string calldata value) public {
        array.push();
        man storage person = array[array.length-1];
        person.name = name;
        person.id = id;
        person.addr = addr;
        person.key = key;
        person.map[key] = value;
        map2[key] = value;
    }

    function get(uint index) public view returns (string memory, uint, address, string memory) {
        man storage res = array[index];
        return (res.name, res.id, res.addr, map2[res.key]);
    }
}

contract Q84 {
    // 2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요. 
    // 단, 이 모든 함수들은 blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
    address[] blacklist;

    modifier isBlacklist(address addr) {
        uint l = blacklist.length;
        for (uint i=0; i<l; i++) {
            if (blacklist[i] == addr) {
                revert("you are blacklist");
            }
        }
        _;
    }

    function add(uint a, uint b) public view isBlacklist(msg.sender) returns (uint) {
        return a+b;
    }

    function sub(uint a, uint b) public view isBlacklist(msg.sender) returns (uint) {
        return a-b;
    }

    function mul(uint a, uint b) public view isBlacklist(msg.sender) returns (uint) {
        return a*b;
    }

    function div(uint a, uint b) public view isBlacklist(msg.sender) returns (uint) {
        return a/b;
    }
}

contract Q85 {
    // 숫자 변수 2개를 구현하세요. 
    // 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 
    // 찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
    uint public startBlock;
    uint public a;
    uint public b;

    constructor () {
        startBlock = block.number;
    }

    function q85(bool vote) public {
        require(startBlock + 20 > block.number, "vote done");
        if (vote) a++;
        else b++;
    }
}

contract Q86 {
    // 숫자 변수 2개를 구현하세요. 
    // 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다. 
    // 찬성, 반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.
    uint public a;
    uint public b;
    mapping(address => uint) balance;

    function q86(bool vote) public {
        require(balance[msg.sender] >= 1 ether, "you must deposit more than 1 ether");
        if (vote) a++;
        else b++;
    }
}

contract Q87 {
    // visibility에 신경써서 구현하세요. 
    // 숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요. 
    // 변화시키는 것도 오직 내부에서만 할 수 있게 해주세요.
    uint private a;
    function q87 (uint _a) internal {
        a = _a;
    } 
}

// 아래의 코드를 보고 owner를 변경시키는 방법을 생각하여 구현하세요.
// 힌트 : 상속
contract OWNER {
	address private owner;

	constructor() {
		owner = msg.sender;
	}

    function setInternal(address _a) internal {
        owner = _a;
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}

contract Q88 is OWNER {
    function q88(address _a) public {
        setInternal(_a);
    }
}

contract Q89 {
    // 이름과 자기 소개를 담은 고객이라는 구조체를 만드세요. 
    // 이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요. 
    // (띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
    struct customer {
        string name;
        string intro;
    }
    customer public c;

    function set(string calldata name, string calldata intro) public {
        uint nameL = bytes(name).length;
        uint introL = bytes(intro).length;
        require(nameL >= 5 && nameL <= 10 && introL >= 20 && introL <=50, "check");
        c = customer(name, intro);
    }
}

contract Q90 {
    // 당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
    function q90() public view returns (string memory) {
        bytes20 walletBytes = bytes20(msg.sender);
        bytes memory result;
        bytes2[10] memory part;

        for (uint i = 0; i < 10; i++) {
            part[i] = bytes2(
                (uint16(uint8(walletBytes[i * 2])) << 8) | uint16(uint8(walletBytes[i * 2 + 1]))
            );
            result = abi.encodePacked(result, _bytes2ToASCII(part[i]));
        }

        return string(result);
    }

    function _bytes2ToASCII(bytes2 data) internal pure returns (bytes memory) {
        bytes memory asciiChars = new bytes(2);

        for (uint i = 0; i < 2; i++) {
            uint8 charCode = uint8(data[i]);
            if (charCode >= 0x20 && charCode <= 0x7E) {
                asciiChars[i] = bytes1(charCode);
            }
        }

        bytes memory nonEmptyChars = new bytes(2);
        uint counter = 0;
        for (uint i = 0; i < 2; i++) {
            if (asciiChars[i] != 0x00) {
                nonEmptyChars[counter] = asciiChars[i];
                counter++;
            }
        }

        bytes memory result = new bytes(counter);
        for (uint i = 0; i < counter; i++) {
            result[i] = nonEmptyChars[i];
        }

        return result;
    }   
}
