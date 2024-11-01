// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IKAP20} from "../IKAP20.sol";

interface IKAP22 is IKAP20 {
    function transfer(address from, address to, uint256 period, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 period, uint256 value) external returns (bool);
    function balanceOf(address account, uint256 period) external returns (uint256);
    function adminTransferPreviousPeriod(address from, address to, uint256 period, uint256 value) external returns (bool);

    function currentIndex() external view returns (uint256);
    function currentPeriod() external view returns (uint256);
    function startTime() external view returns (uint256);
    function periodLength() external view returns (uint256);
}