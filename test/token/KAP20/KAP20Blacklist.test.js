const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("KAP20Blacklist", function () {
  const TOKEN = {
    projectname: "My Token Project" ,
    name: "My Token",
    symbol: "MTKN",
    decimals: 18,
  }
  let accounts
  let token

  beforeEach(async () => {
    const KAP20 = await ethers.getContractFactory("KAP20Blacklist");
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
    );
    await token.deployed();
  });

  describe("KAP20Blacklist get", function () {
    it("has blacklist", async function () {
      expect(await token.hasBlacklist(accounts[0].address)).to.equal(false);
    });
  });
   
});
