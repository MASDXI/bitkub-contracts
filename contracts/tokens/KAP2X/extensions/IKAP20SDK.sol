// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IKAP20} from "../IKAP20.sol";

interface IKAP20SDK is IKAP20 {

    error KAP20SDKRestrictedOnlyExecutor();

    function approveBySDK(
        address owner,
        address spender,
        uint256 amount
    ) external returns (bool);

    function transferFromBySDK(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}
