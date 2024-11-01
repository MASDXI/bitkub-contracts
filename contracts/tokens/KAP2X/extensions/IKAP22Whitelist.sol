// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IKAP22} from "./IKAP22.sol";

interface IKAP22Whitelist is IKAP22 {
    // event
    function isWhitelist(address account) external returns (bool);

    // addWhitelistAddress
    // revokeWhitelistAddress
}
