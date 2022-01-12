// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IKYCBitkubChain {
    function kycsLevel(address contractAddress) external view returns (uint256);
}
