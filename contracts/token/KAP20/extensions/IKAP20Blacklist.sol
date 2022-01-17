// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IKAP20.sol";

/// @author <author>@bitkub.com
/// @title extension interface KAP20Blacklist for KAP-20 Token Standard
interface IKAP20Blacklist is IKAP20 {
    function hasBlacklist(address account) external view returns (bool);

    function addBlacklist(address account) external returns (bool);

    function revokeBlacklist(address account) external returns (bool);

    event BlacklistAdded(address indexed account, address indexed caller);
    event BlacklistRevoked(address indexed account, address indexed caller);
}
