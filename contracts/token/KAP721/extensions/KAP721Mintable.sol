// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./KAP721Enumerable.sol";

abstract contract KAP721Mintable is KAP721Enumerable {
    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }

    function mintBatch(address to, uint8 amount) external {
        uint256 currentId = KAP721Enumerable.totalSupply();
        require(amount > 0, "KAP721Capped: greater than zero");
        for (uint8 i = 0; i <= amount; i++) {
            _mint(to, currentId + i);
        }
    }
}
