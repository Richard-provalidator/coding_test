/*
숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요. (숫자는 작은수에서 큰수로)
예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   3,5,9 // 28712 -> 5,   1,2,2,7,8
--------------------------------------------------------------------------------------------
문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요. (알파벳은 순서대로)
예) abde -> 4,   a,b,d,e // fkeadf -> 6,   a,d,e,f,f,k

소문자 대문자 섞이는 상황은 그냥 생략하셔도 됩니다
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract test12 {
    function number(uint n) public pure returns (uint l, uint[] memory numbers) {
        uint temp = n;
        while (temp > 0) {
            temp /= 10;
            l++;
        }
        numbers = new uint[](l);
        temp = n;
        for (uint i=0; i < l; i++) {
            numbers[i] = temp % 10;
            temp /= 10;
        }
        for (uint i=0; i < l; i++) {
            for (uint j=i; j < l; j++) {
                if (numbers[i] > numbers[j]) {
                    (numbers [i], numbers[j]) = (numbers [j], numbers[i]);
                }
            }
        }
    }

    function str(string memory s) public pure returns (uint l, string[] memory ss) {
        bytes memory sBytes = bytes(s);
        l = sBytes.length;

        ss = new string[](l);
        for (uint256 i = 0; i < l; i++) {
            ss[i] = string(abi.encodePacked(sBytes[i]));
        }

        for (uint256 i = 0; i < l; i++) {
            for (uint256 j = i; j < l; j++) {
                if (sBytes[i] > sBytes[j]) {
                    (ss[i], ss[j]) = (ss[j], ss[i]);
                }
            }
        }
    }
}
