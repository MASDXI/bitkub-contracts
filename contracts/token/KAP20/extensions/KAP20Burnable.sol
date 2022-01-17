// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../KAP20.sol";

/// @author <author>@bitkub.com
/// @title extension burn feature for KAP-20 Token Standard
abstract contract KAP20Burnable is KAP20 {
    function burn(uint256 amount) external whenNotPaused {
        _burn(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) external whenNotPaused {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(
            currentAllowance >= amount,
            "KAP20: burn amount exceeds allowance"
        );
        unchecked {
            _approve(account, _msgSender(), currentAllowance - amount);
        }
        _burn(account, amount);
    }
}
