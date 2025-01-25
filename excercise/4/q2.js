const { expect } = require("chai");
const { int } = require("hardhat/internal/core/params/argumentTypes");

describe("Q2 Liquidity Pool Tests", function () {
  var Q2A, Q2B, Q2;
  var owner, user1, user2, user3, user4;

  beforeEach(async function () {
    // 계정 가져오기
    [owner, user1, user2, user3, user4] = await ethers.getSigners();

    // 컨트랙트 배포
    Q2A = await ethers.deployContract("Q2A");
    Q2B = await ethers.deployContract("Q2B");
    Q2 = await ethers.deployContract("Q2", [Q2A.target, Q2B.target]);

    // 초기 토큰 분배 및 승인
    await Q2A.connect(owner).mint(10000000);
    await Q2B.connect(owner).mint(10000000);
    await Q2A.connect(owner).approve(Q2.target, 10000000);
    await Q2B.connect(owner).approve(Q2.target, 10000000);

    await Q2A.connect(user1).mint(10000000);
    await Q2A.connect(user2).mint(10000000);
    await Q2A.connect(user3).mint(10000000);
    await Q2B.connect(user1).mint(10000000);
    await Q2B.connect(user2).mint(10000000);
    await Q2B.connect(user3).mint(10000000);

    await Q2A.connect(user1).approve(Q2.target, 10000000);
    await Q2A.connect(user2).approve(Q2.target, 10000000);
    await Q2A.connect(user3).approve(Q2.target, 10000000);
    await Q2B.connect(user1).approve(Q2.target, 10000000);
    await Q2B.connect(user2).approve(Q2.target, 10000000);
    await Q2B.connect(user3).approve(Q2.target, 10000000);
  });

  it("Q2 test add liquidity", async function () {
    await Q2.connect(owner).addLiquidity(Q2A.target, 500000);
    var [startQ2A, startQ2B] = await Q2.getBalance();
    expect(startQ2A).to.equal(500000);
    expect(startQ2B).to.equal(2500000);
    expect(await Q2.balanceOf(owner.address)).to.equal(2500000);

    // 시나리오 1
    await Q2.connect(user1).addLiquidity(Q2A.target, 50000);
    var [s1Q2A, s1Q2B] = await Q2.getBalance();
    console.log("after scene1 user1 provided Q2B", s1Q2B - startQ2B);
    console.log(
      "after scene1 user1 LP balance",
      await Q2.balanceOf(user1.address)
    );

    // 시나리오 2
    await Q2.connect(user2).addLiquidity(Q2B.target, 100000);
    var [s2Q2A, s2Q2B] = await Q2.getBalance();
    console.log("after scene2 user2 provided Q2A", s2Q2A - s1Q2A);
    console.log(
      "after scene2 user2 LP balance",
      await Q2.balanceOf(user2.address)
    );

    // 시나리오 3
    var [bal_a, bal_b] = await Q2.getBalance();
    var i = 0;
    while (bal_b.toString() / bal_a.toString() > 2.5) {
      var [whileA, whileB] = await Q2.getBalance();
      await Q2.connect(user3).swap(Q2A.target, 2500);
      [bal_a, bal_b] = await Q2.getBalance();
      console.log(`after scene${3 + i} user3 Q2B balance`, whileB - bal_b);
      console.log(
        `after scene${3 + i} K changed`,
        whileA * whileB - bal_a * bal_b
      );
      i++;
    }
  });
});
