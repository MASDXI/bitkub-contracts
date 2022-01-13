const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MockKAP20", function () {
  const TOKEN = {
    projectname: "My Token Project" ,
    name: "My Token",
    symbol: "MTKN",
    decimals: 18,
    hardcap: ethers.utils.parseEther("1000000")
  }
  let accounts
  let token

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

  describe("MockKAP20 get", function () {
    it("has blacklist", async function () {
      expect(await token.hasBlacklist(accounts[0].address)).to.equal(false);
    });

    it("has hardcap", async function () {
        expect(await token.hardcap()).to.equal(TOKEN.hardcap);
    });
  });
   
});
