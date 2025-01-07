// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q21 {
    // 21. 3의 배수만 들어갈 수 있는 array를 구현하세요.
    uint[] public array;
    function q21(uint n) public {
        if (n % 3 == 0) array.push(n);
    }
}

contract Q22 {
    // 22. 뺄셈 함수를 구현하세요. 임의의 두 숫자를 넣으면 자동으로 둘 중 큰수로부터 작은 수를 빼는 함수를 구현하세요.
    // 예) 2,5 input → 5-2=3(output)
    function q22 (uint a, uint b) public pure returns (uint) {
        uint answer =  a - b;
        if (a < b) answer = b - a;
        return answer;
    }
}

contract Q23 {
    // 23. 3의 배수라면 “A”를, 나머지가 1이 있다면 “B”를, 나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.
    function q23(uint n) public pure returns (string memory) {
        string memory answer;
        if (n % 3 == 0) answer = "A";
        if (n % 3 == 1) answer = "B";
        if (n % 3 == 2) answer = "C";
        return answer;
    }
}

contract Q24 {
    // 24. string을 input으로 받는 함수를 구현하세요. “Alice”가 들어왔을 때에만 true를 반환하세요.
    function q24(string calldata s) public pure returns (bool) {
        bool answer;
        if (keccak256(bytes(s)) == keccak256(bytes("Alice"))) answer = true;
        return answer;
    } 
}

contract Q25 {
    // 25. 배열 A를 선언하고 해당 배열에 n부터 0까지 자동으로 넣는 함수를 구현하세요. 
    uint[] public A;
    function q25(uint n) public {
        for (uint i=n+1; i > 0; i--) {
            A.push(i-1);
        }
    }
}

contract Q26 {
    // 26. 홀수만 들어가는 array, 짝수만 들어가는 array를 구현하고 숫자를 넣었을 때 자동으로 홀,짝을 나누어 입력시키는 함수를 구현하세요.
    uint[] public array1;
    uint[] public array2;
    function q26(uint n) public {
        if (n % 2 == 0) array2.push(n);
        else array1.push(n);
    }
}

contract Q27 {
    // 27. string 과 bytes32를 key-value 쌍으로 묶어주는 mapping을 구현하세요. 해당 mapping에 정보를 넣고, 지우고 불러오는 함수도 같이 구현하세요.
    mapping (string => bytes32) q27map;

    function set(string calldata key) public {
        q27map[key] = keccak256(bytes(key));
    }

    function get(string calldata key) public view returns (bytes32) {
        return q27map[key];
    }

    function del(string calldata key) public {
        delete q27map[key];
    }
}

contract Q28 {
    // 28. ID와 PW를 넣으면 해시함수(keccak256)에 둘을 같이 해시값을 반환해주는 함수를 구현하세요.
    function q28(string calldata id, string calldata pw) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(id, pw));
    }
}

contract Q29 {
    // 29. 숫자형 변수 a와 문자형 변수 b를 각각 10 그리고 “A”의 값으로 배포 직후 설정하는 contract를 구현하세요.
    uint public a;
    string public b;
    constructor() {
        a = 10;
        b = "A";
    }
    
}

contract Q30 {
    // 30. 임의대로 숫자를 넣으면 알아서 내림차순으로 정렬해주는 함수를 구현하세요
    // (sorting 코드 응용 → 약간 까다로움)
    // 예 : [2,6,7,4,5,1,9] → [9,7,6,5,4,2,1]
    function q30(uint[] memory array) public pure returns (uint[] memory) {
        for (uint i = 0; i < array.length; i++) {
            for (uint j = i+1; j < array.length; j++) {
                if (array[i] < array[j]) {
                    uint temp = array[i];
                    array[i] = array[j];
                    array[j] = temp;
                }
            }
        }

        return array;
    }

}
