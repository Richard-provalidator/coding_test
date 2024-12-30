// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Q11 {
    // 11. uint 형이 들어가는 array를 선언하고, 짝수만 들어갈 수 있게 걸러주는 함수를 구현하세요.
    uint[] public array;
    function even(uint _a) public {
        if (_a % 2 == 0) {
            array.push(_a);
        }
    }
}

contract Q12 {
    // 12. 숫자 3개를 더해주는 함수, 곱해주는 함수 그리고 순서에 따라서 a*b+c를 반환해주는 함수 3개를 각각 구현하세요.
    function add(uint a, uint b, uint c) public pure returns (uint) {
        return a+b+c;
    }

    function mul(uint a, uint b, uint c) public pure returns (uint) {
        return a*b*c;
    }

    function order(uint a, uint b, uint c) public pure returns (uint) {
        return a*b+c;
    }
}

contract Q13 {
    // 13. 3의 배수라면 “A”를, 나머지가 1이 있다면 “B”를, 나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.
    function triple(uint n) public pure returns (string memory) {
        if (n % 3 == 0) {
            return "A";
        }
        if (n % 3 == 1) {
            return "B";
        }
        if (n % 3 == 2) {
            return "C";
        }
        return "";
    }
}

contract Q14 {
    // 14. 학번, 이름, 듣는 수험 목록을 포함한 학생 구조체를 선언하고 학생들을 관리할 수 있는 array를 구현하세요. array에 학생을 넣는 함수도 구현하는데 학생들의 학번은 1번부터 순서대로 2,3,4,5 자동 순차적으로 증가하는 기능도 같이 구현하세요.
    struct student {
        uint number;
        string name;
        string class;
    }
    student[] public array;

    function addStudent(string memory name, string memory class) public {
        uint len = array.length;
        array.push(student(len+1, name, class));
    }

}

contract Q15 {
    // 15. 배열 A를 선언하고 해당 배열에 0부터 n까지 자동으로 넣는 함수를 구현하세요.
    uint[] public A;

    function pushN(uint n) public {
        for (uint i=0; i<=n; i++) {
            A.push(i);
        }
    }

}

contract Q16 {
    // 16. 숫자들만 들어갈 수 있는 array를 선언하고 해당 array에 숫자를 넣는 함수도 구현하세요. 또 array안의 모든 숫자의 합을 더하는 함수를 구현하세요.
    uint[] array;

    function push(uint n) public {
        array.push(n);
    }

    function sumF() public view returns (uint) {
        uint sum;
        for (uint i=0; i<array.length; i++) {
            sum += array[i];
        }
        return sum;
    }

}

contract Q17 {
    // 17. string을 input으로 받는 함수를 구현하세요. 이 함수는 true 혹은 false를 반환하는데 Bob이라는 이름이 들어왔을 때에만 true를 반환합니다. 
    function isBob(string memory name) public pure returns (bool) {
        return keccak256(bytes(name)) == keccak256(bytes("Bob"));
    }

}

contract Q18 {
    // 18. 이름을 검색하면 생일이 나올 수 있는 자료구조를 구현하세요. (매핑) 해당 자료구조에 정보를 넣는 함수, 정보를 볼 수 있는 함수도 구현하세요.
    mapping (string => uint) public map;
    
    function setBirthday(string memory name, uint birthday) public {
        require(bytes(name).length > 0, "Name cannot be empty");
        require(birthday >= 19000101 && birthday <= 21001231, "Invalid birthday format (YYYYMMDD)");
        map[name] = birthday;
    }

    function getBirthday(string memory name) public view returns (uint) {
        require(bytes(name).length > 0, "Name cannot be empty");
        uint birthday = map[name];
        require(birthday > 0, "Birthday not found for this name");
        return birthday;
    }

}

contract Q19 {
    // 19. 숫자를 넣으면 2배를 반환해주는 함수를 구현하세요. 단 숫자는 1000이상 넘으면 함수를 실행시키지 못하게 합니다.
    function double(uint n) public pure returns (uint) {
        require(n < 1000, "This function is not working over 1000");
        return n*2;
    }

}

contract Q20 {
    // 20. 숫자만 들어가는 배열을 선언하고 숫자를 넣는 함수를 구현하세요. 15개의 숫자가 들어가면 3의 배수 위치에 있는 숫자들을 초기화 시키는(3번째, 6번째, 9번째 등등) 함수를 구현하세요. (for 문 응용 → 약간 까다로움)
    uint[] numbers;

    function addNumber(uint256 num) public {
        numbers.push(num);
        if (numbers.length == 15) {
            for (uint i=numbers.length-1; i>0; i--) {
                if (i % 3 == 0) {
                    delete numbers[i];
                }
            }
        }
    }

    function getNumbers() public view returns (uint256[] memory) {
        return numbers;
    }

}
