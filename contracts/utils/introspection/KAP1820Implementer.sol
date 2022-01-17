// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/KAP1820Implementer.sol)

pragma solidity ^0.8.0;

import "./IKAP1820Implementer.sol";

/**
 * @dev Implementation of the {IKAP1820Implementer} interface.
 *
 * Contracts may inherit from this and call {_registerInterfaceForAddress} to
 * declare their willingness to be implementers.
 * {IKAP1820Registry-setInterfaceImplementer} should then be called for the
 * registration to be complete.
 */
contract KAP1820Implementer is IKAP1820Implementer {
    bytes32 private constant _KAP1820_ACCEPT_MAGIC =
        keccak256("KAP1820_ACCEPT_MAGIC");

    mapping(bytes32 => mapping(address => bool)) private _supportedInterfaces;

    /**
     * @dev See {IKAP1820Implementer-canImplementInterfaceForAddress}.
     */
    function canImplementInterfaceForAddress(
        bytes32 interfaceHash,
        address account
    ) public view virtual override returns (bytes32) {
        return
            _supportedInterfaces[interfaceHash][account]
                ? _KAP1820_ACCEPT_MAGIC
                : bytes32(0x00);
    }

    /**
     * @dev Declares the contract as willing to be an implementer of
     * `interfaceHash` for `account`.
     *
     * See {IKAP1820Registry-setInterfaceImplementer} and
     * {IKAP1820Registry-interfaceHash}.
     */
    function _registerInterfaceForAddress(
        bytes32 interfaceHash,
        address account
    ) internal virtual {
        _supportedInterfaces[interfaceHash][account] = true;
    }
}
