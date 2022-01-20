// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../KAP1155.sol";

abstract contract KAP1155Mintable is KAP1155 {
    /// adding
    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        _mint(to, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        _mintBatch(to, ids, amounts, data);
    }
}
