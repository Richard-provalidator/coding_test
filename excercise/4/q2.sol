// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import "hardhat/console.sol";

contract Q2A is ERC20("A", "A"){

    constructor() {}

    function decimals() override public view virtual returns (uint8) {
        return 0;
    }

    function mint(uint n) public {
        _mint(msg.sender, n);
    }
}

contract Q2B is ERC20("B", "B"){

    constructor() {}

    function decimals() override public view virtual returns (uint8) {
        return 0;
    }

    function mint(uint n) public {
        _mint(msg.sender, n);
    }
}

contract Q2 is ERC20("Q2", "Q2") {
    ERC20 public token_a;
    ERC20 public token_b;

    constructor(address _a, address _b) {
        token_a = ERC20(_a);
        token_b = ERC20(_b);
    }

    function getBalance() public view returns (uint bal_a, uint bal_b) {
        bal_a = token_a.balanceOf(address(this));
        bal_b = token_b.balanceOf(address(this));
    }

    function getLPBalance() public view returns (uint) {
        return totalSupply();
    }

    function addLiquidity(address addr, uint _n) public {
        (uint bal_a, uint bal_b) = getBalance();
        bool isA = addr == address(token_a);

        uint _x;
        if (isA) {
            uint _m = bal_a == 0 ? 2500000 : _n * bal_b / bal_a;
            token_a.transferFrom(tx.origin, address(this), _n);
            token_b.transferFrom(tx.origin, address(this), _m);

            _x = bal_a == 0 ? _n*5 : totalSupply() * _n / bal_a;
        } else {
            uint _m = _n * bal_a / bal_b;

            token_a.transferFrom(tx.origin, address(this), _m);
            token_b.transferFrom(tx.origin, address(this), _n);

            _x = totalSupply() * _n / bal_b;
        }

        _mint(msg.sender, _x);
    }

    function withdrawLiquidity(uint _n) public {

        (uint bal_a, uint bal_b) = getBalance();

        uint _a = _n * bal_a / totalSupply();
        uint _b = _n * bal_b / totalSupply();

        _burn(msg.sender, _n);

        token_a.transfer(msg.sender, _a);
        token_b.transfer(msg.sender, _b);
    }

    function withdrawAllLiquidity() public {
        uint _n = balanceOf(msg.sender);

        (uint bal_a, uint bal_b) = getBalance();

        uint _a = _n * bal_a / totalSupply();
        uint _b = _n * bal_b / totalSupply();

        _burn(msg.sender, _n);

        token_a.transfer(msg.sender, _a);
        token_b.transfer(msg.sender, _b);
    }

    function swap(address addr, uint _n) public {
        (uint bal_a, uint bal_b) = getBalance();

        uint k = bal_a * bal_b;

        bool isA = addr == address(token_a);

        if (isA) {
            uint out = bal_b - k / (bal_a + _n) * 999 / 1000;
            token_a.transferFrom(msg.sender, address(this), _n);
            token_b.transfer(msg.sender, out);
        } else {
            uint out = bal_a - k / (bal_b + _n) * 999 / 1000;
            token_b.transferFrom(msg.sender, address(this), _n);
            token_a.transfer(msg.sender, out);
        }
        (bal_a, bal_b) = getBalance();
        uint price = bal_b * 1e18 / bal_a;
        if (price <= 2.5 * 1e18) console.log("warning, price is under 2.5");
        
    }
}
