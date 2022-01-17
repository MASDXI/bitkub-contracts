// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IKAP820Implementer.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface for an KAP820 implementer, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1820#interface-implementation-erc1820implementerinterface[EIP].
 * Used by contracts that will be registered as implementers in the
 * {IKAP820Registry}.
 */
interface IKAP1820Implementer {
    /**
     * @dev Returns a special value (`KAP820_ACCEPT_MAGIC`) if this contract
     * implements `interfaceHash` for `account`.
     *
     * See {IKAP820Registry-setInterfaceImplementer}.
     */
    function canImplementInterfaceForAddress(
        bytes32 interfaceHash,
        address account
    ) external view returns (bytes32);
}
