// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/KAP1155/utils/KAP1155Receiver.sol)

pragma solidity ^0.8.0;

import "../IKAP1155Receiver.sol";
import "../../../utils/introspection/KAP165.sol";

/**
 * @dev _Available since v3.1._
 */
abstract contract KAP1155Receiver is KAP165, IKAP1155Receiver {
    /**
     * @dev See {IKAP165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(KAP165, IKAP165)
        returns (bool)
    {
        return
            interfaceId == type(IKAP1155Receiver).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
