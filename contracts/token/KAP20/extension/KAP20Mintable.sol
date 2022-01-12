// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../KAP20.sol";

/// @author <author>@bitkub.com
/// @title extension burn feature for KAP-20 Token Standard
abstract contract KAP20Mintable is KAP20 {
    function mint(address recipient, uint256 amount)
        external
        onlySuperAdmin
        returns (bool)
    {
        _mint(recipient, amount);
        return true;
    }
}
