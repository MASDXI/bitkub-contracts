// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/KAP165.sol)

pragma solidity ^0.8.0;

import "./IKAP165.sol";

/**
 * @dev Implementation of the {IKAP165} interface.
 *
 * Contracts that want to implement KAP165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {KAP165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract KAP165 is IKAP165 {
    /**
     * @dev See {IKAP165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IKAP165).interfaceId;
    }
}
