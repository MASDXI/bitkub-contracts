// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IKAP20.sol";

interface IKAP20Legacy is IKAP20 {

    function adminApprove(
        address owner,
        address spender,
        uint256 amount
    ) external returns (bool);

    function internalTransfer(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function externalTransfer(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}
