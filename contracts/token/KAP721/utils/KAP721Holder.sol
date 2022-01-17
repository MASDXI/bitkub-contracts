// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/KAP721/utils/KAP721Holder.sol)

pragma solidity ^0.8.0;

import "../IKAP721Receiver.sol";

/**
 * @dev Implementation of the {IKAP721Receiver} interface.
 *
 * Accepts all token transfers.
 * Make sure the contract is able to use its token with {IKAP721-safeTransferFrom}, {IKAP721-approve} or {IKAP721-setApprovalForAll}.
 */
contract KAP721Holder is IKAP721Receiver {
    /**
     * @dev See {IKAP721Receiver-onKAP721Received}.
     *
     * Always returns `IKAP721Receiver.onKAP721Received.selector`.
     */
    function onKAP721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onKAP721Received.selector;
    }
}
