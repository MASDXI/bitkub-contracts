// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IKAP20} from "../IKAP20.sol";

interface IKAP22 is IKAP20 {

    /// @custom:obervation not necessary need 
    // event Mint(uint256 indexed period, address indexed receiver, uint256 amount);
    // event Burn(address indexed owner, uint256 amount);
    // function mint(uint256 amount, address receiver) external returns (bool);
    // function burn(uint256 period, uint256 amount, address owner) external returns (bool);
    // function cap() external view returns (uint256); // capped can be seperate extention

    // event Transfer(address indexed from, address indexed to, uint256 indexed period, uint256 amount); // maybe useful
    function transfer(address from, address to, uint256 period, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 period, uint256 amount) external returns (bool);
    function balanceOf(address account, uint256 period) external returns (uint256);

    // function adminTransferPreviousPeriod(address from, address to, uint256 period, uint256 amount) external returns (bool);

    function currentIndex() external view returns (uint256);
    function currentPeriod() external view returns (uint256);
    function startTime() external view returns (uint256);
    function periodLength() external view returns (uint256);
}