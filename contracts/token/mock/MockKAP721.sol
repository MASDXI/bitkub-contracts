// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../KAP721/KAP721.sol";
import "../KAP721/extensions/KAP721Enumerable.sol";
import "../KAP721/extensions/KAP721Blacklist.sol";
import "../KAP721/extensions/KAP721Burnable.sol";
import "../KAP721/extensions/KAP721URIStorage.sol";

contract MockKAP721 is
    KAP721,
    KAP721Blacklist,
    KAP721Burnable,
    KAP721Enumerable,
    KAP721URIStorage
{
    constructor(
        string memory project_,
        string memory name_,
        string memory symbol_,
        address admin_,
        address kyc_,
        address committee_,
        uint8 acceptedKycLevel_
    )
        KAP721(
            project_,
            name_,
            symbol_,
            admin_,
            kyc_,
            committee_,
            acceptedKycLevel_
        )
    {}

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(KAP721, KAP721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(KAP721, KAP721Blacklist, KAP721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        virtual
        override(KAP721, KAP721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(KAP721, KAP721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
