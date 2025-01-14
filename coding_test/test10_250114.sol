/*
A라고 하는 erc-20(decimal 0)을 발행하고, B라는 NFT를 발행하십시오.
A 토큰은 개당 0.001eth 정가로 판매한다.
B NFT는 오직 A로만 구매할 수 있고 가격은 50으로 시작합니다.
첫 10명은 50A, 그 다음 20명은 100A, 그 다음 40명은 200A로 가격이 상승합니다. (추가는 안해도 됨)

B를 burn 하면 20 A만큼 환불 받을 수 있고, 만약에 C라고 하는 contract에 전송하면 30A 만큼 받는 기능도 구현하세요.
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract tokenA is ERC20 {
    address owner;

    constructor() ERC20("tokenA", "A") {
        owner = msg.sender;
    }

    function decimals() override public view virtual returns (uint8) {
        return 0;
    }

    function buyToken() public payable {
        require(msg.value > 0, "need more than 0.001 ether");
        _mint(_msgSender(), msg.value / 0.001 ether);
    }
}

contract tokenB is ERC721 {
    tokenA A;
    constructor(address addrA) ERC721("tokenB", "B") {
        A = tokenA(addrA);
    }

    uint price;
    uint buyCount;

    function onERC721Received(address, address, uint256, bytes memory) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function buyToken() public payable {
        if (buyCount < 10) price = 50;
        else if (buyCount < 30) price = 100;
        else price = 200;
        require(A.balanceOf(_msgSender()) >= price, "need more than price");
        A.transferFrom(_msgSender(), address(this), price);

        uint256 tokenId = buyCount;
        _safeMint(_msgSender(), tokenId);
        buyCount++;

    }

    function burnToken(uint tokenId) public {
        _burn(tokenId);
        A.transfer(_msgSender(), 20);
    }

    function sendToC(uint tokenId, address c) public {
        _safeTransfer(_msgSender(), c, tokenId);
        A.transfer(_msgSender(), 30);
    }
}

contract C {
    function onERC721Received(address, address, uint256, bytes memory) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
