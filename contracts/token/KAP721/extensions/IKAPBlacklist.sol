// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../IKAP721.sol";

interface IKAP721Blacklist is IKAP721 {
    function hasBlacklist(address account) external view returns (bool);

    function addBlacklist(address account) external returns (bool);

    function revokeBlacklist(address account) external returns (bool);

    event BlacklistAdded(address indexed account, address indexed caller);
    event BlacklistRevoked(address indexed account, address indexed caller);
}