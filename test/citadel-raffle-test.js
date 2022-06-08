var chai = require("chai");
const expect = chai.expect;
const { solidity } = require("ethereum-waffle");

chai.use(solidity);

// Start test block
describe("citadel nft", function () {
  whitelist = [
    "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
    "0x56DBD1086A7c9E3A3Aca1414fBA45a99d20Ef05F",
    "0x29d7d1dd5b6f9c864d9db560d72a247c178ae86b",
    "0xe4fEB387cB1dAff4bf9108581B116e5FA737Bea2",
    "0xDFd5293D8e347dFe59E90eFd55b2956a1343963d",
    "0x1eb026649B6ac698cBad1dA9abD5a8fD54E09132",
    "0x11b58341350ae2b89be7Fadf646F116803611B93",
    "0x70997970c51812dc3a010c7d01b50e0d17dc79c8",
  ];
  before(async function () {
    this.Raffle = await ethers.getContractFactory("CitadelRaffle");
  });

  beforeEach(async function () {
    this.raffle = await this.Raffle.deploy(
      "Raffle",
      "Raffle",
      "https://gateway.pinata.cloud/ipfs/QmUEWVbqGG31kVZqTBZsEYk3z26djBPMPxhHxuV3893kHX/"
    );
    await this.raffle.deployed();
  });

  describe("bounds", function () {
    it("does not exceed 3", async function () {
      await this.citadel.updateParameters(0, 3);
      for (var i = 0; i < 100000; i++) {
        const random = this.citadel.random();

        expect(random).greaterThanOrEqual(0);
        expect(random).lessThanOrEqual(3);
      }
    });

    it("does not exceed 50, does not succeed 44", async function () {
      await this.citadel.updateParameters(44, 50);
      for (var i = 0; i < 100000; i++) {
        const random = this.citadel.random();

        expect(random).greaterThanOrEqual(44);
        expect(random).lessThanOrEqual(50);
      }
    });
  });
});
