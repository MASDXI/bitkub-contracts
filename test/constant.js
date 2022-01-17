const { ethers } = require("hardhat");

const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const ONE_MILLION = ethers.utils.parseEther("1000000");
const TWO_MILLION = ethers.utils.parseEther("2000000");
const ONE_TOKEN = ethers.utils.parseEther("1");
const PROJECT_NAME = "ProjectName";
const NAME = "Name";
const SYMBOL = "NT";
const DECIMALS = 18;

const TOKEN = {
  projectname: PROJECT_NAME,
  name: NAME,
  symbol: SYMBOL,
  decimals: DECIMALS,
  hardcap: ONE_MILLION,
  premine: ONE_MILLION,
  excess_premine: TWO_MILLION,
};

module.exports = {
  TOKEN,
  ZERO_ADDRESS,
  ONE_MILLION,
  TWO_MILLION,
  ONE_TOKEN,
};
