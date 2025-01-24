// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q91 {
    // 배열에서 특정 요소를 없애는 함수를 구현하세요. 
    // 예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
    function q91(uint[] memory ns, uint n) public pure returns (uint[] memory) {
        uint l = ns.length;
        uint[] memory temps = new uint[](l -1);
        uint index;
        
        for (uint i=0; i<l; i++) {
            if (i != n-1) {
                temps[index] = ns[i];
                index++;
            }
        }
        return temps;
    }
}

contract Q92 {
    // 특정 주소를 받았을 때, 그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
    function q92(address addr) public view returns (string memory res) {
        res = "CA";
        if (addr.code.length == 0) {
            res = "EOA";
        }
    }
}

contract Q93 {
    // 다른 컨트랙트의 함수를 사용해보려고 하는데, 
    // 그 함수의 이름은 모르고 methodId로 추정되는 값은 있다. 
    // input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
    // GPT 사용해서 구현했습니다.
    function q93(
        address target, // 호출 대상 컨트랙트 주소
        bytes4 methodId, // 함수의 메서드 ID
        uint256 param1, // 첫 번째 매개변수 (uint256)
        address param2 // 두 번째 매개변수 (address)
    ) public returns (bool, bytes memory) {
        require(target != address(0), "Invalid target address");

        // ABI 인코딩을 사용해 메서드 ID와 파라미터를 함께 준비
        bytes memory data = abi.encodeWithSelector(methodId, param1, param2);

        // `call`로 외부 컨트랙트 호출
        (bool success, bytes memory result) = target.call(data);

        // 성공 여부와 결과 반환
        return (success, result);
    }
}

contract Q94 {
    // inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
    function add(uint a, uint b) public pure returns (uint res) {
        assembly {
            res := add(a, b)
        }
    }

    function sub(uint a, uint b) public pure returns (uint res) {
        assembly {
            res := sub(a, b)
        }
    }

    function mul(uint a, uint b) public pure returns (uint res) {
        assembly {
            res := mul(a, b)
        }
    }

    function div(uint a, uint b) public pure returns (uint res) {
        assembly {
            res := div(a, b)
        }
    }
}

contract Q95 {
    // inline - 3개의 값을 받아서, 더하기, 곱하기한 결과를 반환하는 함수를 구현하세요.
    function add(uint a, uint b, uint c) public pure returns (uint res) {
        assembly {
            res := add(a, add(b, c))
        }
    }

    function mul(uint a, uint b, uint c) public pure returns (uint res) {
        assembly {
            res := mul(a, mul(b, c))
        }
    }
}

contract Q96 {
    // inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    function q96(uint a, uint b, uint c, uint d) public pure returns (uint max, uint min) {
        assembly {
            max := a
            min := a

            if lt(max, b) { max := b }
            if lt(max, c) { max := c }
            if lt(max, d) { max := d }

            if gt(min, b) { min := b }
            if gt(min, c) { min := c }
            if gt(min, d) { min := d }
        }
    }
}

contract Q97 {
    // inline - 상태변수 숫자만 들어가는 동적 array numbers에 push하고 
    // pop하는 함수 그리고 전체를 반환하는 구현하세요.
    uint[] public numbers;
    function push(uint _n) public {
        assembly {
            let slot1 := numbers.slot
            let length1 := sload(slot1)

            mstore(0x0, slot1)

            let start1 := keccak256(slot1, 0x20)
            let current1 := add(start1, length1)

            sstore(current1, _n)
            sstore(slot1, add(length1, 1))
        }
    }

    function pop() public {
        assembly {
            let slot1 := numbers.slot
            let length1 := sload(slot1)
            if iszero(length1) {revert(0,0)}

            mstore(0x100, slot1)

            let start1 := keccak256(0x100, 0x20)
            let last1 := add(start1, sub(length1, 1))

            sstore(last1, 0)
            sstore(slot1, sub(length1, 1))
        }
    }

    function getNumbers() public view returns(uint[] memory) {
        return numbers;
    }
}

contract Q98 {
    // inline - 상태변수 문자형 letter에 값을 넣는 함수 setLetter를 구현하세요.
    string public letter;
    function setLetter(string memory l) public {
        
    }
}

contract Q99 {
    // inline - bytes4형 b의 값을 정하는 함수 setB를 구현하세요.
    bytes4 public b;
    function setB(bytes4 _b) public {
        
    }
}

contract Q100 {
    // inline - bytes형 변수 b의 값을 정하는 함수 setB를 구현하세요.
    bytes public b;
    function setB(bytes memory _b) public {

    }
}
