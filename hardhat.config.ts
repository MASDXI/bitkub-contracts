import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.27",
  networks: {
    mainnet: {
      url: "https://rpc.bitkubchain.io/",
      accounts: [],
      chainId: 96
    },
    testnet: {
      url: "https://rpc-testnet.bitkubchain.io/",
      accounts: [],
      chainId: 25925
    },
    khaosan_testnet: {
      url: "https://khaosan-rpc.bitkubchain.io",
      accounts: [],
      chainId: 25925
    },
  },
  mocha: {
    timeout: 200000,
    slow: 0,
  },
  gasReporter: {
    enabled: true,
  },

};

export default config;
