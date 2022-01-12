// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../KAP20.sol";

/// @author <author>@bitkub.com
/// @title extension capped feature for KAP-20 Token Standard
abstract contract KAP20Capped is KAP20 {
    uint256 private immutable _cap;

    constructor(uint256 cap_) {
        require(cap_ > 0, "KAP20Capped: cap is 0");
        _cap = cap_;
    }

    function hardcap() public view virtual returns (uint256) {
        return _cap;
    }

    function _mint(address account, uint256 amount) internal virtual override {
        require(
            KAP20.totalSupply() + amount <= hardcap(),
            "KAP20Capped: hardcap exceeded"
        );
        super._mint(account, amount);
    }
}
