/*
은행에 관련된 어플리케이션을 만드세요.
은행은 여러가지가 있고, 유저는 원하는 은행에 넣을 수 있다. 
국세청은 은행들을 관리하고 있고, 세금을 징수할 수 있다. 
세금은 간단하게 전체 보유자산의 1%를 징수한다. 세금을 자발적으로 납부하지 않으면 강제징수한다. 

* 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
* 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
* 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
* 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
* 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
* 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
-------------------------------------------------------------------------------------------------
* 은행간 송금 기능 수수료 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
* 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract test9 {

    struct TaxCollector {
        address addr;
        uint balance;
    }

    TaxCollector taxCollector;

    constructor() {
        taxCollector.addr = msg.sender;
    }

    struct user {
        address addr;
        mapping(string => uint) balances;
        mapping(string => bool) isBankAccount;
        mapping(string => uint) taxes;
    }

    struct bank {
        string name;
        uint bankBalance;
    }

    mapping (address => user) public users;
    mapping (string => bank) public banks;
    user[] usersArray;
    bank[] banksArray;

    function singUp(string calldata bankName) public {
        users[msg.sender].addr = msg.sender;
        users[msg.sender].balances[bankName] = 0;
        users[msg.sender].isBankAccount[bankName] = true;

        if (bytes(banks[bankName].name).length == 0) {
            banks[bankName].name = bankName;
        }
    }

    modifier isSignup(string calldata bankName) {
        require(users[msg.sender].isBankAccount[bankName], "You Need to Sign up first");
        _;
    }

    function deposit(string calldata bankName) isSignup(bankName) public payable {

        users[msg.sender].balances[bankName] += msg.value;
        banks[bankName].bankBalance += msg.value;
        users[msg.sender].taxes[bankName] += msg.value / 100;
    }

    function withdraw(string calldata bankName, uint amount) isSignup(bankName) public {
        require(users[msg.sender].balances[bankName] - users[msg.sender].taxes[bankName] >= amount, "Not enough balance");

        users[msg.sender].balances[bankName] -= amount;
        users[msg.sender].taxes[bankName] -= amount / 100;

        payable(msg.sender).transfer(amount);
    }

    function transfer1(string calldata from, string calldata to, uint amount) isSignup(from) isSignup(to) public {
        require(users[msg.sender].balances[from] >= amount, "Not enough balance");

        users[msg.sender].balances[from] -= amount;
        users[msg.sender].balances[to] += amount;
    }

    function transfer2(string calldata from, string calldata to, address toUser, uint amount) isSignup(from) public {
        uint totalAmount = amount + 1000000000000000 wei;
        require(users[toUser].isBankAccount[to], "toUser's bank is not signed up");
        require(users[msg.sender].balances[from] >= totalAmount, "Not enough balance and fee");

        users[msg.sender].balances[from] -= totalAmount;
        users[toUser].balances[to] += amount;
        banks[from].bankBalance += 1000000000000000 wei; // A 은행에 수수료 적립
    }

    function taxPay(string calldata bankName) isSignup(bankName) public {
        uint amount = users[msg.sender].taxes[bankName];
        require(amount > 0, "No taxes to pay");
        require(users[msg.sender].balances[bankName] >= amount, "Not enough balance");

        users[msg.sender].taxes[bankName] = 0;
        taxCollector.balance += amount;
    }

    function forceCollectTax(address userAddr, string calldata bankName) public {
        require(msg.sender == address(this), "Only admin can force tax collection");

        uint taxAmount = users[userAddr].taxes[bankName];
        require(taxAmount > 0, "No taxes to collect");

        if (users[userAddr].balances[bankName] >= taxAmount) {
            users[userAddr].balances[bankName] -= taxAmount;
            banks[bankName].bankBalance -= taxAmount;
            taxCollector.balance += taxAmount;

            users[userAddr].taxes[bankName] = 0;
        }
    }
}
