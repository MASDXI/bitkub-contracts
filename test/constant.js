const { ethers } = require("hardhat");

const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";
const ONE_MILLION = ethers.utils.parseEther("1000000");
const TWO_MILLION = ethers.utils.parseEther("2000000");
const ONE_TOKEN = ethers.utils.parseEther("1");
const NEGATIVE_VALUE = 1;
const POSITIVE_VALUE = -1;
const PROJECT_NAME = "ProjectName";
const NAME = "Name";
const SYMBOL = "NT";
const DECIMALS = 18;
const URI = "https://mock.kap/api/v1/token=id?";

const TOKEN = {
  projectname: PROJECT_NAME,
  name: NAME,
  symbol: SYMBOL,
  decimals: DECIMALS,
  hardcap: ONE_MILLION,
  premine: ONE_MILLION,
  excess_premine: TWO_MILLION,
};

const KAP721 = {
  projectname: PROJECT_NAME,
  name: NAME,
  symbol: SYMBOL,
  uri: URI,
};

const KAP1155 = {
  projectname: PROJECT_NAME,
  name: NAME,
  symbol: SYMBOL,
  uri: URI,
};

module.exports = {
  TOKEN,
  ZERO_ADDRESS,
  NEGATIVE_VALUE,
  POSITIVE_VALUE,
  ONE_MILLION,
  TWO_MILLION,
  ONE_TOKEN,
  KAP721,
  KAP1155,
};
