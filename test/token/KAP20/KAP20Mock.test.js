const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MockKAP20", function () {
  const TOKEN = {
    projectname: "My Token Project",
    name: "My Token",
    symbol: "MTKN",
    decimals: 18,
    hardcap: ethers.utils.parseEther("1000000"),
  };
  let accounts;
  let token;

  beforeEach(async () => {
    const KAP20 = await ethers.getContractFactory("MockToken");
    accounts = await ethers.getSigners();
    token = await KAP20.deploy(
      TOKEN.projectname,
      TOKEN.name,
      TOKEN.symbol,
      TOKEN.decimals,
      4,
      accounts[0].address,
      accounts[0].address,
      accounts[0].address,
      accounts[0].address,
      TOKEN.hardcap
    );
    await token.deployed();
  });

  describe("MockKAP20Capped feature", function () {
    it("has hardcap", async function () {
      expect(await token.hardcap()).to.equal(TOKEN.hardcap);
    });

    it("mint under hardcap", async function () {});

    it("mint over hardcap", async function () {});
  });

  describe("MockKAP20Blacklist feature", function () {
    it("has blacklist", async function () {
      expect(await token.hasBlacklist(accounts[0].address)).to.equal(false);
    });

    it("add blacklist emit event", async function () {
      await expect(token.addBlacklist(accounts[1].address))
        .to.emit(token, "BlacklistAdded")
        .withArgs(accounts[1].address, accounts[0].address);
    });

    it("revoke blacklist emit event", async function () {
      await token.addBlacklist(accounts[1].address);
      await token.revokeBlacklist(accounts[1].address);
      expect(await token.hasBlacklist(accounts[1].address)).to.equal(false);
    });

    it("try transfer to blacklist address", async function () {});

    it("try transfer to non blacklist address", async function () {});
  });
});
