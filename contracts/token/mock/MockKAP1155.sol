// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../KAP1155/KAP1155.sol";
import "../KAP1155/extensions/KAP1155Blacklist.sol";
import "../KAP1155/extensions/KAP1155Burnable.sol";
import "../KAP1155/extensions/KAP1155Mintable.sol";
import "../KAP1155/extensions/KAP1155Supply.sol";

contract MockKAP1155 is
    KAP1155,
    KAP1155Blacklist,
    KAP1155Burnable,
    KAP1155Supply
{
    constructor(
        string memory uri_,
        string memory project_,
        address admin_,
        address committee_,
        address kyc_,
        uint8 acceptedKycLevel_
    ) KAP1155(uri_, project_, admin_, committee_, kyc_, acceptedKycLevel_) {}

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override(KAP1155, KAP1155Blacklist, KAP1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
