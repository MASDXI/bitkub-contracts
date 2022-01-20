const { expect } = require("chai");
const { ethers } = require("hardhat");
const constant = require("../../constant");
const { TOKEN } = constant;

describe("KAP1155Base", function () {
  let accounts;
  let token;

  beforeEach(async () => {
    const KAP1155 = await ethers.getContractFactory("KAP1155");
    accounts = await ethers.getSigners();
    token = await KAP1155.deploy(
      TOKEN.uri,
      TOKEN.projectname,
      accounts[0].address,
      accounts[0].address,
      accounts[0].address,
      4
    );
    await token.deployed();
  });

  describe("KAP1155Base feature", function () {
    it("has a project name", async function () {
      expect(await token.project()).to.equal(TOKEN.projectname);
    });

    it("has committee", async function () {
      expect(await token.committee()).to.equal(accounts[0].address);
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
