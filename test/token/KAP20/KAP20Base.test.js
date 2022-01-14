const { expect } = require("chai");
const { ethers } = require("hardhat");
const constant = require("./constant");
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

    it("set unpaused to paused emit event", async function () {
      await expect(token.pause())
        .to.emit(token, "Paused")
        .withArgs(accounts[0].address);
    });

    it("set paused to unpaused  emit event", async function () {
      await token.pause();
      await expect(token.unpause())
        .to.emit(token, "Unpaused")
        .withArgs(accounts[0].address);
    });
  });
});
