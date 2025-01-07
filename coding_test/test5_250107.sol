/*
로또 프로그램을 만드려고 합니다. 
숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. (순서는 상관없음)

참가 금액은 0.05이더이다.

당첨번호 : 7,3,2,5,B,C
예시 1  : 8,2,4,7,D,A -> 맞은 번호 : 2     (1개)
예시 2  : 9,1,4,2,F,B -> 맞은 번호 : 2,B   (2개)
예시 3  : 2,3,4,6,A,B -> 맞은 번호 : 2,3,B (3개)
*/
// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract test5 {
    address admin;
    
    uint8[4] Numbers;
    string[2] Letters;

    constructor() {
        admin = msg.sender;
    }
    
    function setWin(uint8[4] memory numbers, string[2] memory letters) public {
        require(msg.sender == admin, "this function is for admin");
        Numbers = numbers;
        Letters = letters;
    }

    function lotto(uint8[4] memory numbers, string[2] memory letters) public payable returns (uint) {
        uint fee = 0.05 ether;
        require(msg.value == fee, "lotto fee is 0.05 ether");

        uint win;
        win += numberCheck(numbers);
        win += letterCheck(letters);

        
        uint prize = setPrize(win);

        require(address(this).balance >= prize, "Insufficient contract balance");
        payable(msg.sender).transfer(prize);

        return win;
    }

    function letterCheck(string[2] memory letters) internal view returns (uint) {
        uint win;
        for (uint i=0; i < Letters.length; i++) {
            for (uint j=0; j < letters.length; j++) {
                if (keccak256(bytes(Letters[i])) == keccak256(bytes(letters[j]))) {
                    win++;
                    break;
                }
            }
        }
        return win;
    }

    function numberCheck(uint8[4] memory numbers) internal view returns (uint) {
        uint win;
        for (uint i=0; i < Numbers.length; i++) {
            for (uint j=0; j < numbers.length; j++) {
                if (Numbers[i] == numbers[j]) {
                    win++;
                    break;
                }
            }
        }
        return win;
    }

    function setPrize(uint win) internal pure returns (uint) {
        uint256 prize;
        if (win == 6) prize = 1 ether;
        if (win == 5) prize = 0.75 ether;
        if (win == 4) prize = 0.25 ether;
        if (win == 3) prize = 0.1 ether;

        return prize;
    }
}
