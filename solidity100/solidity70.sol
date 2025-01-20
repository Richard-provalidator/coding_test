// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q61 {
    // a의 b승을 반환하는 함수를 구현하세요.
    function q61(uint a, uint b) public pure returns (uint) {
        return a ** b;
    }
}

contract Q62 {
    // 2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데 
    // 3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.
    modifier lt10(uint a, uint b) {
        require(a<=10 && b<=10, "input must less than 10");
        _;
    }
    function q62_1(uint a, uint b) public pure lt10(a, b) returns (uint) {
        return a+b;
    }

    function q62_2(uint a, uint b) public pure lt10(a, b) returns (uint) {
        return a*b;
    }
    
    function q62_3(uint a, uint b) public pure lt10(a, b) returns (uint) {
        return a ** b;
    }
}

contract Q63 {
    // 2개 숫자의 차를 나타내는 함수를 구현하세요.
    function q63(uint a, uint b) public pure returns (uint) {
        if (a > b) return a -b;
        else return b-a;
    }
}

contract Q64 {
    // 지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세요.
    function q64(address _a) public pure returns (bytes4[5] memory res) {
        bytes20 addrBytes = bytes20(_a);

        for (uint i = 0; i < 5; i++) {
            res[i] = bytes4(slice(abi.encodePacked(addrBytes), i * 4, (i + 1) * 4));
        }
    }

    function slice(bytes memory data, uint start, uint end) internal pure returns (bytes memory res) {
        res = new bytes(end - start);

        for (uint i = start; i < end; i++) {
            res[i - start] = data[i];
        }
    }
}

contract Q65 {
    // 1. 숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요. 
    // 그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.
    // 예) func A : input → 1,2,3 // output → 1,4,9 | func B : output 4 (1,4,9중 가운데 숫자)
    uint a;
    uint b;
    uint c;
    
    function q65(uint _a, uint _b, uint _c) public returns (uint, uint, uint) {
        a = _a**2;
        b = _b**2;
        c = _c**2;
        return (a**2, b**2, c**2);
    }

    function q65_2() public view returns (uint) {
        uint[3] memory res = [a, b, c];
        for (uint i=0; i<3; i++) {
            for (uint j=i; j<3; j++) {
                if (res[i] > res[j]) {
                    (res[i], res[j]) = (res[j], res[i]);
                }
            }
        }
        return res[1];
    }
}

contract Q66 {
    // 특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요. 
    // 추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
    function q66(uint a) public pure returns (uint res) {
        while (a > 0) {
            a /= 10;
            res++;
        }
    }

    function q66_2(uint256 a) public pure returns (uint res) {
        if (a == 0) {
            return 1;
        }
        
        while (a > 0) {
            a /= 5;
            res++;
        }
    }
}

// 자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 
// 다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
// B의 함수를 이용하여 A에게 전송하고 A의 잔고 변화를 확인하세요.
contract A {
    function a() public view returns (uint) {
        return address(this).balance;
    }

    function deposit() public payable {}
}

contract B {
    function b(address payable _a, uint _b) public {
        _a.transfer(_b);
    }

    function deposit() public payable {}
}

contract Q68 {
    // 계승(팩토리얼)을 구하는 함수를 구현하세요. 
    // 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다. 
    // 예) 5 → 1*2*3*4*5 = 60, 11 → 1*2*3*4*5*6*7*8*9*10*11 = 39916800
    // while을 사용해보세요
    function q68(uint a) public pure returns (uint res) {
        res = 1;
        while (a>0) {
            res *= a;
            a--;
        }
    }
}

contract Q69 {
    // 숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
    // 힌트 : 7번 문제(시,분,초로 변환하기)
    function q69(uint _a, uint _b, uint _c) public pure returns (string memory) {
        string memory part1 = numChange(_a);
        string memory part2 = numChange(_b);
        string memory part3 = numChange(_c);

        return string(abi.encodePacked(part1, " and ", part2, " or ", part3));
    }

    function numChange(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        bytes memory bstr = new bytes(78);
        uint256 j = _i;
        uint256 len = 0;
        while (j != 0) {
            bstr[len++] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }

        bytes memory result = new bytes(len);
        for (uint256 k = 0; k < len; k++) {
            result[k] = bstr[len - 1 - k];
        }
        return string(result);
    }
}

contract Q70 {
    // 번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요. 
    // bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다. 
    // 고객의 정보를 넣고 변화시키는 함수를 구현하세요. 
    struct customer {
        uint id;
        string name;
        bytes hash;
    }
    customer public A;

    function q70(uint _id, string calldata _name) public {
        A = customer(_id, _name, abi.encodePacked(keccak256(abi.encodePacked(_id, _name))));
    }
}
