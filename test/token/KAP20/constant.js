const { ethers } = require("hardhat");

const TOKEN = {
  projectname: "My Token Project",
  name: "My Token",
  symbol: "MTKN",
  decimals: 18,
  hardcap: ethers.utils.parseEther("1000000"),
};

const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

module.exports = { TOKEN, ZERO_ADDRESS };
