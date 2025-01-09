/*
흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.

입력값을 받으면 그 입력값 안에 대문자, 소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 알려주는 함수를 구현하세요.
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract test7 {
    function password(string calldata pw) public pure returns (bool pass) {
        bytes memory pwBytes = bytes(pw);
        bool uppercase;
        bool lowercase;
        bool number;

        for (uint i=0; i < pwBytes.length; i++) {
            bytes1 word = pwBytes[i];

            if (word >= 0x41 && word <= 0x5a) uppercase = true;
            if (word >= 0x61 && word <= 0x7a) lowercase = true;
            if (word >= 0x30 && word <= 0x39) number = true;
        }

        if (uppercase && lowercase && number) pass = true;
        return pass;
    }
}
