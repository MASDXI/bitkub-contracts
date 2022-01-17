// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/KAP1155/utils/KAP1155Holder.sol)

pragma solidity ^0.8.0;

import "./KAP1155Receiver.sol";

/**
 * Simple implementation of `KAP1155Receiver` that will allow a contract to hold KAP1155 tokens.
 *
 * IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
 * stuck.
 *
 * @dev _Available since v3.1._
 */
contract KAP1155Holder is KAP1155Receiver {
    function onKAP1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onKAP1155Received.selector;
    }

    function onKAP1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onKAP1155BatchReceived.selector;
    }
}
