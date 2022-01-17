// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/KAP721/extensions/KAP721Burnable.sol)

pragma solidity ^0.8.0;

import "../KAP721.sol";
import "../../../utils/Context.sol";

/**
 * @title KAP721 Burnable Token
 * @dev KAP721 Token that can be irreversibly burned (destroyed).
 */
abstract contract KAP721Burnable is Context, KAP721 {
    /**
     * @dev Burns `tokenId`. See {KAP721-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `tokenId` or be an approved operator.
     */
    function burn(uint256 tokenId) public virtual {
        //solhint-disable-next-line max-line-length
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "KAP721Burnable: caller is not owner nor approved"
        );
        _burn(tokenId);
    }
}
