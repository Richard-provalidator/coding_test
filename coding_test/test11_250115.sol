/*
숫자를 시분초로 변환하세요.
예) 100 -> 1분 40초, 600 -> 10분, 1000 -> 16분 40초, 5250 -> 1시간 27분 30초
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract test11 {
    function convert(uint n) public pure returns (string memory) {
        uint h;
        uint m;
        uint s;

        h = n / 3600;
        n %= 3600;
        m = n / 60;
        s = n % 60;

        if (h > 0) {
            if (m > 0 && s > 0) {
                return string(abi.encodePacked(h, unicode"시간 ", m, unicode"분 ", s, unicode"초"));
            }
            if (m > 0 && s == 0) {
                return string(abi.encodePacked(h, unicode"시간 ", m, unicode"분"));
            }
            if (m == 0 && s > 0) {
                return string(abi.encodePacked(h, unicode"시간 ", s, unicode"초"));
            }
            if (m == 0 && s == 0) {
                return string(abi.encodePacked(h, unicode"시간"))
            }
        } else if (m > 0) {
            return string(abi.encodePacked(m, unicode"분 ", s, unicode"초"));
        } else {
            return string(abi.encodePacked(s, unicode"초"));
        }
    }
}
