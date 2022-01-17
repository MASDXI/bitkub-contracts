// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.8.0;

contract IKAP20Metadata {
    function name() external view returns (string);

    function symbol() external view returns (string);

    function decimals() external view returns (uint8);
    
    function totalSupply() external view returns (uint256)
}