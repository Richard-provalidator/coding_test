/*
자동차와 관련된 어플리케이션을 만들면 됩니다.
1개의 smart contract가 자동차라고 생각하시고, 구조체를 활용하시면 편합니다.

아래의 기능들을 구현하세요.

* 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
* 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
* 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
* 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
* 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
--------------------------------------------------------
* 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
*/

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract test8 {
    struct Car {
        uint speed;
        uint fuel;
        bool isEngineOn;
    }

    Car car;
    mapping(address => uint) public balance;

    constructor() {
        car = Car(0, 100, false);
    }

    modifier engineCheck() {
        require(car.isEngineOn, "Engine is off. need to engine on.");
        _;
    }

    // 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    function accelCar() public engineCheck {
        require(car.fuel > 30, "Need more fuel, less than 30 now.");
        require(car.speed < 70, "Too much speed, more than 70 now");

        car.speed += 10;
        car.fuel -= 20;
    }

    // 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    function refuel() public payable {
        if (balance[msg.sender] >= 1 ether) balance[msg.sender] -= 1 ether;
        else require(msg.value == 1 ether, "Refuel need 1 ether");

        car.fuel = 100;
    }

    // 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    function breakCar() public engineCheck {
        require(car.fuel > 0, "Need more fuel, less than 0 now.");
        require(car.speed > 0, "Too low speed, 0 now");

        car.speed -= 10;
        car.fuel -= 10;
    }
    
    // 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    function stopEngine() public {
        require(car.isEngineOn, "Engine is already off");
        require(car.speed == 0, "Speed need to 0 when engine off");

        car.isEngineOn = false;
    }

    // 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    function startEngine() public {
        require(!car.isEngineOn, "Engine is already on");
        
        car.isEngineOn = true;
    }

    // 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    function addBalance() public payable {
        require(msg.value > 0, "Send ether to charge balance");

        balance[msg.sender] += msg.value;
    }



}
