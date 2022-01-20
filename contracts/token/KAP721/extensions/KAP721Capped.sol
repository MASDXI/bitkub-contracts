// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./KAP721Enumerable.sol";

abstract contract KAP721Mintable is KAP721Enumerable {
    uint256 private _hardcap;

    constructor(uint256 hardcap_) {
        _hardcap = hardcap_;
    }

    function hardcap() public view returns (uint256) {
        return _hardcap;
    }

    function _mint(address to, uint256 tokenId) internal virtual override {
        require(
            KAP721Enumerable.totalSupply() + 1 <= hardcap(),
            "KAP721Capped: hardcap exceeded"
        );
        super._mint(to, tokenId);
    }
}
