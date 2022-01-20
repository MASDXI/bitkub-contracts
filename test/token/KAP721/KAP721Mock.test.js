const { expect } = require("chai");
const { ethers } = require("hardhat");
const constant = require("../../constant");
const { TOKEN, ZERO_ADDRESS } = constant;

describe("MockKAP721", function () {
  let accounts;
  let token;

  beforeEach(async () => {
    const KAP721 = await ethers.getContractFactory("MockKAP721");
    accounts = await ethers.getSigners();
    token = await KAP721.deploy(
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

  describe("MockKAP721Capped feature", function () {
    it("has hardcap", async function () {
      expect(await token.hardcap()).to.equal(TOKEN.hardcap);
    });

    it("mint under hardcap", async function () {});

    it("mint over hardcap", async function () {});
  });

  describe("MockKAP721Blacklist feature", function () {
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
        "KAP721Blacklist: account must not in blacklist"
      );
    });

    it("try to revoke not exist blacklist account", async function () {
      await expect(
        token.revokeBlacklist(accounts[1].address)
      ).to.be.revertedWith("KAP721Blacklist: account must be in blacklist");
    });

    it("try to add blacklist zero address should be reverted", async function () {
      await expect(token.addBlacklist(ZERO_ADDRESS)).to.be.revertedWith(
        "KAP721Blacklist: can't blacklist default address"
      );
    });

    it("try to revoke blacklist zero address should be reverted", async function () {
      await expect(token.revokeBlacklist(ZERO_ADDRESS)).to.be.revertedWith(
        "KAP721Blacklist: can't blacklist default address"
      );
    });

    it("try transfer from non blacklist to blacklist address", async function () {
      await token.addBlacklist(accounts[1].address);
      await expect(
        token.connect(accounts[0]).transfer(accounts[1].address, 1)
      ).to.be.revertedWith("KAP721Blacklist: to address must not in blacklist");
    });

    it("try transfer from blacklist address to non blacklist address", async function () {
      await token.connect(accounts[0]).transfer(accounts[1].address, 1);
      await token.addBlacklist(accounts[1].address);
      await expect(
        token.connect(accounts[1]).transfer(accounts[0].address, 1)
      ).to.be.revertedWith(
        "KAP721Blacklist: form address must not in blacklist"
      );
    });
  });

  describe("MockKAP721Burnable feature", function () {
    it("try burn", async function () {
      await token.burn(ethers.utils.parseEther("1"));
      expect((await token.balanceOf(accounts[0].address)).toString()).to.equal(
        "99999000000000000000000"
      );
    });

    it("try burnForm", async function () {
      await token.approve(accounts[1].address, 1);
      await token.connect(accounts[1]).burnFrom(accounts[0].address, 1);
      expect((await token.balanceOf(accounts[0].address)).toString()).to.equal(
        "99999999999999999999999"
      );
    });

    it("try burnForm exceeds allowance", async function () {
      await token.approve(accounts[1].address, 1);
      await expect(
        token.connect(accounts[1]).burnFrom(accounts[0].address, 10)
      ).to.be.revertedWith("KAP721: burn amount exceeds allowance");
    });
  });

  describe("MockKAP721Mintable feature", function () {
    it("mint admin", async function () {});

    it("mint non admin", async function () {});
  });
});
