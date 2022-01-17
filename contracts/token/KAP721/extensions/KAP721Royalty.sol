// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (token/KAP721/extensions/KAP721Royalty.sol)

pragma solidity ^0.8.0;

import "../KAP721.sol";
import "../../common/KAP2981.sol";
import "../../../utils/introspection/KAP165.sol";

/**
 * @dev Extension of KAP721 with the KAP2981 NFT Royalty Standard, a standardized way to retrieve royalty payment
 * information.
 *
 * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
 * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
 *
 * IMPORTANT: KAP-2981 only specifies a way to signal royalty information and does not enforce its payment. See
 * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
 * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
 *
 * _Available since v4.5._
 */
abstract contract KAP721Royalty is KAP2981, KAP721 {
    /**
     * @dev See {IKAP165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(KAP721, KAP2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {KAP721-_burn}. This override additionally clears the royalty information for the token.
     */
    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
    }
}
