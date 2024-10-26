// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IKAP20.sol";

interface IKAP20TransferRouter is IKAP20 {

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
