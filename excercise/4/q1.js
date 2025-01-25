const { expect } = require("chai");

describe("Q1 Liquidity Pool Tests", function () {
  var Q1A, Q1B, Q1;
  var owner, user1, user2, user3, user4;

  beforeEach(async function () {
    // 계정 가져오기
    [owner, user1, user2, user3, user4] = await ethers.getSigners();

    // 컨트랙트 배포
    Q1A = await ethers.deployContract("Q1A");
    Q1B = await ethers.deployContract("Q1B");
    Q1 = await ethers.deployContract("Q1", [Q1A.target, Q1B.target]);

    // 초기 토큰 분배 및 승인
    await Q1A.connect(owner).mint(10000000);
    await Q1B.connect(owner).mint(10000000);
    await Q1A.connect(owner).approve(Q1.target, 10000000);
    await Q1B.connect(owner).approve(Q1.target, 10000000);

    await Q1A.connect(user1).mint(10000000);
    await Q1A.connect(user2).mint(10000000);
    await Q1A.connect(user3).mint(10000000);
    await Q1A.connect(user4).mint(10000000);
    await Q1B.connect(user1).mint(10000000);
    await Q1B.connect(user2).mint(10000000);
    await Q1B.connect(user3).mint(10000000);
    await Q1B.connect(user4).mint(10000000);

    await Q1A.connect(user1).approve(Q1.target, 10000000);
    await Q1A.connect(user2).approve(Q1.target, 10000000);
    await Q1A.connect(user3).approve(Q1.target, 10000000);
    await Q1A.connect(user4).approve(Q1.target, 10000000);
    await Q1B.connect(user1).approve(Q1.target, 10000000);
    await Q1B.connect(user2).approve(Q1.target, 10000000);
    await Q1B.connect(user3).approve(Q1.target, 10000000);
    await Q1B.connect(user4).approve(Q1.target, 10000000);
  });

  it("Q1 test add liquidity", async function () {
    await Q1.connect(owner).addLiquidity(Q1A.target, 100000);
    var [startQ1A, startQ1B] = await Q1.getBalance();
    expect(startQ1A).to.equal(100000);
    expect(startQ1B).to.equal(300000);
    expect(await Q1.balanceOf(owner.address)).to.equal(1000000);

    // 시나리오 1
    await Q1.connect(user1).addLiquidity(Q1A.target, 30000);
    var [s1Q1A, s1Q1B] = await Q1.getBalance();
    console.log("after scene1 user1 provided Q1B", s1Q1B - startQ1B);
    console.log(
      "after scene1 user1 LP balance",
      await Q1.balanceOf(user1.address)
    );

    // 시나리오 2
    await Q1.connect(user2).addLiquidity(Q1B.target, 60000);
    var [s2Q1A, s2Q1B] = await Q1.getBalance();
    console.log("after scene2 user2 provided Q1A", s2Q1A - s1Q1A);
    console.log(
      "after scene2 user2 LP balance",
      await Q1.balanceOf(user2.address)
    );

    // 시나리오 3
    await Q1.connect(user3).swap(Q1A.target, 25000);
    var [s3Q1A, s3Q1B] = await Q1.getBalance();
    console.log("after scene3 user3 Q1B balance", s2Q1B - s3Q1B);
    console.log("after scene3 K changed", s2Q1A * s2Q1B - s3Q1A * s3Q1B);

    // 시나리오 4
    await Q1.connect(user4).swap(Q1B.target, 50000);
    var [s4Q1A, s4Q1B] = await Q1.getBalance();
    console.log("after scene4 user4 Q1A balance", s3Q1A - s4Q1A);
    console.log("after scene4 K changed", s3Q1A * s3Q1B - s4Q1A * s4Q1B);

    // 시나리오 5
    await Q1.connect(user1).withdrawAllLiquidity();
    var [s5Q1A, s5Q1B] = await Q1.getBalance();
    console.log(
      "after scene5 user1 Q1A, Q1B balance",
      s4Q1A - s5Q1A,
      s4Q1B - s5Q1B
    );
    console.log("after scene5 K changed", s4Q1A * s4Q1B - s5Q1A * s5Q1B);

    // 시나리오 6
    await Q1.connect(user2).withdrawAllLiquidity();
    var [s6Q1A, s6Q1B] = await Q1.getBalance();
    console.log(
      "after scene6 user2 Q1A, Q1B balance",
      s5Q1A - s6Q1A,
      s5Q1B - s6Q1B
    );
    console.log("after scene6 K changed", s5Q1A * s5Q1B - s6Q1A * s6Q1B);
  });
});
