// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IKAP20 {
    function adminTransfer(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function adminApprove(
        address owner,
        address spender,
        uint256 amount
    ) external returns (bool);
}
