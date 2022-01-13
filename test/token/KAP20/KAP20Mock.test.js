const { expect } = require("chai");
const { ethers } = require("hardhat");
const constant = require("./constant");
const { TOKEN, ZERO_ADDRESS } = constant;

describe("MockKAP20", function () {
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
      await expect(token.revokeBlacklist(accounts[1].address))
        .to.emit(token, "BlacklistRevoked")
        .withArgs(accounts[1].address, accounts[0].address);
    });

    it("try to added exist blacklist account", async function () {
      await token.addBlacklist(accounts[1].address);
      await expect(token.addBlacklist(accounts[1].address)).to.be.revertedWith(
        "KAP20Blacklist: account must not in blacklist"
      );
    });

    it("try to added exist blacklist account", async function () {
      await expect(
        token.revokeBlacklist(accounts[1].address)
      ).to.be.revertedWith("KAP20Blacklist: account must be in blacklist");
    });

    it("try to add blacklist zero address should be reverted", async function () {
      await expect(token.addBlacklist(ZERO_ADDRESS)).to.be.revertedWith(
        "KAP20Blacklist: can't blacklist deafult address"
      );
    });

    it("try to revoke blacklist zero address should be reverted", async function () {
      await expect(token.revokeBlacklist(ZERO_ADDRESS)).to.be.revertedWith(
        "KAP20Blacklist: can't blacklist deafult address"
      );
    });

    it("try transfer to blacklist address", async function () {});

    it("try transfer to non blacklist address", async function () {});
  });
});
