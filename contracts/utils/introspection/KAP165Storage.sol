// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/KAP165Storage.sol)

pragma solidity ^0.8.0;

import "./KAP165.sol";

/**
 * @dev Storage based implementation of the {IKAP165} interface.
 *
 * Contracts may inherit from this and call {_registerInterface} to declare
 * their support of an interface.
 */
abstract contract KAP165Storage is KAP165 {
    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    /**
     * @dev See {IKAP165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return super.supportsInterface(interfaceId) || _supportedInterfaces[interfaceId];
    }

    /**
     * @dev Registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual KAP165 interface is automatic and
     * registering its interface id is not required.
     *
     * See {IKAP165-supportsInterface}.
     *
     * Requirements:
     *
     * - `interfaceId` cannot be the KAP165 invalid interface (`0xffffffff`).
     */
    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "KAP165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}
