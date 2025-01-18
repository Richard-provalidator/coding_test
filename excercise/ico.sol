// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract ico is ERC1155{
    address owner;
    uint public startBlock;

    struct Token {
        uint price;
        uint max;
        uint sold;
        bool isSale;
    }

    struct icoBuyer {
        address addr;
        uint tier;
        uint amount;
    }

    Token[] tokens;
    icoBuyer[] icoBuyers;
    bool done;
    mapping(address => mapping(uint => uint)) public icoBalance;

    constructor() ERC1155("uri_"){
        owner = _msgSender();
        startBlock = block.number;

        tokens.push(Token(0.01 ether, 1000, 0, true)); // Tier 1
        tokens.push(Token(0.05 ether, 500, 0, true));  // Tier 2
        tokens.push(Token(0.1 ether, 200, 0, true));   // Tier 3
        tokens.push(Token(0.2 ether, 100, 0, true));   // Tier 4
    }

    event updateSales(uint tier, uint sold);


    modifier onlyOwner() {
        require(owner == _msgSender(), "Only owner can do this function");
        _;
    }

    modifier onlyDuringSale(bool isSale) {
        require(isSale, "Not for sale now");
        _;
    }

    function allSaleEnd() public {
        for (uint i=0; i < tokens.length; i++) {
            _saleEnd(i+1);
        }
    }

    function saleEnd(uint tier) public {
        _saleEnd(tier);
    }

    function _saleEnd(uint tier) internal {
        tokens[tier-1].isSale = false;
        uint count;
        uint len = tokens.length;
        for (uint i=0; i < len; i++) {
            if (!tokens[i].isSale) count++;
        }
        if (count == tokens.length) done = true;
    }

    function saleOn(uint tier, uint amount) public {
        _saleOn(tier, amount);
    }

    function _saleOn(uint tier, uint amount) internal {
        tokens[tier-1].max += amount;
        tokens[tier-1].isSale = true;
    }

    function update() public {
        uint len = tokens.length;
        for (uint i=0; i < len; i++) {
            tokens[i].price *= 2;
            emit updateSales(i+1, tokens[i].sold);
        }
    }

    function buyToken(uint tier, uint amount) public payable onlyDuringSale(tokens[tier].isSale) {
        require(tier >0 && tier <= tokens.length, "Invalid tier");
        Token storage token = tokens[tier-1];

        require(msg.value >= token.price);

        require(token.sold + amount <= token.max, "Token is sold out");
        token.sold += amount;
        if (token.sold == token.max) _saleEnd(tier);


        icoBuyers.push(icoBuyer(msg.sender, tier, amount));
        icoBalance[msg.sender][tier] += amount;

        if (msg.value > token.price * amount) {
            payable(_msgSender()).transfer(msg.value - token.price * amount);
        }
    }

    function halfMove() public {
        uint len = icoBuyers.length;
        for (uint i=0; i<len; i++) {
            _move(i, icoBuyers[i].addr, icoBuyers[i].tier, icoBuyers[i].amount / 2);
        }
    }

    function allMove() public {
        uint len = icoBuyers.length;
        for (uint i=0; i<len; i++) {
            _move(i, icoBuyers[i].addr, icoBuyers[i].tier, icoBuyers[i].amount);
        }
    }

    function _move(uint i, address addr, uint tier, uint amount) internal {
        icoBuyers[i].amount -= amount;
        icoBalance[addr][tier] -= amount;
        _mint(addr, tier, amount, "");
    }

    function withdraw(uint amount) public onlyOwner {
        require(done == true, "Sale is not done");
        payable(owner).transfer(amount);
    }
}
