// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q31 {
    // 31. string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.
    function q31(string calldata input) public pure returns (bool){
        bool answer;
        if (keccak256(bytes(input)) == keccak256(bytes("Alice")) || keccak256(bytes(input)) == keccak256(bytes("Bob"))) {
            answer = true;
        }
        return answer;
    }
}

contract Q32 {
    // 32. 2, 3의 배수만 들어갈 수 있는 array를 구현하되, 3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
    // 예) 3 → o , 9 → o , 15 → o , 30 → x
    uint[] public array;
    function q32(uint n) public {
        if (n % 2 == 0 || n % 3 == 0) {
            if (n % 3 == 0 && n % 10 == 0) return;
            array.push(n);
        }
    }
}

contract Q33 {
    // 33. 이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
    struct q33 {
        string name;
        uint id;
        address addr;
        uint birthday;
    }
    mapping (string => q33) q33map;

    function setQ33(string calldata name, uint id, address addr, uint birthday) public {
        q33map[name] = q33(name, id, addr, birthday);
    }

    function getQ33(string calldata name) public view returns (q33 memory) {
        return q33map[name];
    }
}

contract Q34 {
    // 34. 이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
    struct q34 {
        string name;
        uint id;
        uint score;
    }
    q34[] q34Array;

    function setArray(string calldata name, uint id, uint score) public {
        q34Array.push(q34(name, id, score));
    }

    function q34F() public view returns (uint) {
        uint sum;
        for (uint i=0; i < q34Array.length; i++) {
            sum += q34Array[i].score;
        }
        return sum / q34Array.length;
    }

}

contract Q35 {
    // 35. 숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
    uint[] array;

    function setArray(uint n) public {
        array.push(n);
    }

    function q35() public view returns (uint[] memory) {
        require(array.length > 0, "array is not ready");
        uint[] memory newArray = new uint[]((array.length -1) /2);
        
        uint j;
        for (uint i=2; i < array.length; i+=2) {
            newArray[j] = array[i];
            j++;
        }
        return newArray;
    }
}

contract Q36 {
    // 36. high, neutral, low 상태를 구현하세요. a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
    enum Enum {
        high,
        neutral,
        low
    }
    Enum public  e;
    function q36(uint a) public {
        if (a>=7) e = Enum.high;
        else if (a>=4) e = Enum.neutral;
        else e = Enum.low;
    }
}

contract Q37 {
    // 37. 1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
    // (힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
    address admin;
    constructor() {
        admin = msg.sender;
    }

    function q37Wei() public payable {
        require(msg.value == 1 wei, "wei transfer only");
    }

    function q37Finney() public payable {
        require(msg.value == 1000000000000000 wei, "finney transfer only");
    }

    function q37Ether() public payable {
        require(msg.value == 1 ether, "ether transfer only");
    }

    function q37Out(uint money) public {
        require(msg.sender == admin, "admin only");
        require(money <= address(this).balance);
        payable(admin).transfer(money);
    }
}

contract Q38 {
    // 38. 상태변수 a를 "A"로 설정하여 선언하세요. 이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
    // (힌트 : 동일한 조건이 서로 다른 두 함수에 적용되니 더욱 효율성 있게 적용시킬 수 있는 방법을 생각해볼 수 있음)
    string public a = "A";

    address owner;
    constructor() {
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner, "owner only");
        _;
    }

    function B() public isOwner {
        a = "B";
    }

    function C() public isOwner {
        a = "C";
    }
}

contract Q39 {
    // 39. 특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
    // 예) 15 : 7,5,3,2  (2의 배수 7개, 3의 배수 5개, 5의 배수 3개, 7의 배수 2개) // 100 : 50,33,20,14  (2의 배수 50개, 3의 배수 33개, 5의 배수 20개, 7의 배수 14개)
    function q39(uint n) public pure returns (uint, uint, uint, uint) {
        return (n/2, n/3, n/5, n/7);
    }
}

contract Q40 {
    // 40. 숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요. 가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
    //예) [5,2,4,7,1] -> [1,2,4,5,7], 4 // [1,5,4,9,6,3,2,11] -> [1,2,3,4,5,6,9,11], 4,5 // [6,3,1,4,9,7,8] -> [1,3,4,6,7,8,9], 6
    function q40(uint[] memory ns) public pure returns (uint[] memory res, uint m, uint mn) {
        for (uint i=0; i< ns.length; i++) {
            for (uint j=i; j< ns.length; j++) {
                if (ns[i] > ns[j]) {
                    uint temp = ns[i];
                    ns[i] = ns[j];
                    ns[j] = temp;
                }
            }
        }
        res = ns;
        uint len = ns.length;
        if (len % 2 == 0) {
            m = ns[len/2 -1];
            mn = ns[len/2];
        } else {
            m = ns[len/2];
        }
    }
}
