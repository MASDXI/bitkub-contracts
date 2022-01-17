// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/KAP721/extensions/KAP721Pausable.sol)

pragma solidity ^0.8.0;

import "../KAP721.sol";
import "../../../security/Pausable.sol";

/**
 * @dev KAP721 token with pausable token transfers, minting and burning.
 *
 * Useful for scenarios such as preventing trades until the end of an evaluation
 * period, or having an emergency switch for freezing all token transfers in the
 * event of a large bug.
 */
abstract contract KAP721Pausable is KAP721, Pausable {
    /**
     * @dev See {KAP721-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - the contract must not be paused.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        require(!paused(), "KAP721Pausable: token transfer while paused");
    }
}
