// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IKAP20} from "../IKAP20.sol";

interface IKAP20TransferRouter is IKAP20 {
    error KAP20OnlyInternalPurpose();
    error KAP20OnlyExternalPurpose();

    function internalTransfer(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function externalTransfer(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}
