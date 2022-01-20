const { expect } = require("chai");
const { ethers } = require("hardhat");
const constant = require("../../constant");
const { TOKEN } = constant;

describe("KAP20Base", function () {
  let accounts;
  let token;

  beforeEach(async () => {
    const KAP20 = await ethers.getContractFactory("KAP20");
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
      accounts[0].address
    );
    await token.deployed();
  });

  describe("KAP20Base feature", function () {
    it("has a project name", async function () {
      expect(await token.project()).to.equal(TOKEN.projectname);
    });

    it("has a name", async function () {
      expect(await token.name()).to.equal(TOKEN.name);
    });

    it("has a symbol", async function () {
      expect(await token.symbol()).to.equal(TOKEN.symbol);
    });

    it("has 18 decimals", async function () {
      expect(await token.decimals()).to.equal(TOKEN.decimals);
    });

    it("has totalSupply", async function () {
      expect(await token.totalSupply()).to.equal(0);
    });

    it("has committee", async function () {
      expect(await token.committee()).to.equal(accounts[0].address);
    });

    it("has admin router", async function () {
      expect(await token.router()).to.equal(accounts[0].address);
    });

    it("has KYC", async function () {
      expect(await token.acceptedKycLevel()).to.equal(4);
    });

    it("is unpaused", async function () {
      expect(await token.paused()).to.equal(false);
    });

    it("set unpaused to paused", async function () {
      await token.pause();
      expect(await token.paused()).to.equal(true);
    });

    it("set paused to unpaused", async function () {
      await token.pause();
      await token.unpause();
      expect(await token.paused()).to.equal(false);
    });

    it("try to paused whenPaused", async function () {
      await token.pause();
      await expect(token.pause()).to.be.revertedWith("Pausable: paused");
    });

    it("try to unpaused whenNotPaused", async function () {
      await expect(token.unpause()).to.be.revertedWith("Pausable: not paused");
    });

    it("try set pause with the role is not allowed.", async function () {
      await expect(token.connect(accounts[2]).pause())
        .to.be.revertedWith("Committee: Restricted only committee")
    });

    it("set unpaused to paused emit event", async function () {
      await expect(token.pause())
        .to.emit(token, "Paused")
        .withArgs(accounts[0].address);
    });

    it("try set unpaused with the role is not allowed.", async function () {
      await token.pause();
      await expect(token.connect(accounts[2]).unpause())
        .to.be.revertedWith("Committee: Restricted only committee")
    });

    it("set paused to unpaused emit event", async function () {
      await token.pause();
      await expect(token.unpause())
        .to.emit(token, "Unpaused")
        .withArgs(accounts[0].address);
    });

    it("try change committee to zero address", async function () {
      await expect(token.setCommittee(TOKEN.ZERO_ADDRESS))
      .to.be.revertedWith("Committee: can't set committee with default address")
    });

    it("try change committee with old address", async function () {
      await expect(token.setCommittee(accounts[0].address))
      .to.be.revertedWith("Committee: already set committee")
    });

    it("change committee emit event", async function () {
      await expect(token.setCommittee(accounts[1].address))
        .to.emit(token, "ComitteeChanged")
        .withArgs(accounts[1].address);
    });

    it("try change admin to zero address", async function () {
      await expect(token.setAdmin(TOKEN.ZERO_ADDRESS))
      .to.be.revertedWith("Authorized: can't set admin with default address")
    });

    it("try change admin with old address", async function () {
      await expect(token.setAdmin(accounts[0].address))
      .to.be.revertedWith("Authorized: already set admin")
    });

    it("change admin emit event", async function () {
      await expect(token.setAdmin(accounts[1].address))
        .to.emit(token, "AdminChanged")
        .withArgs(accounts[1].address);
    });
  });
});
