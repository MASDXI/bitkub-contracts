// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./KAP20/KAP20.sol";
import "./KAP20/extension/KAP20Blacklist.sol";
import "./KAP20/extension/KAP20Capped.sol";
import "./KAP20/extension/KAP20Mintable.sol";
import "./KAP20/extension/KAP20Burnable.sol";

contract MockToken is
    KAP20,
    KAP20Blacklist,
    KAP20Capped,
    KAP20Mintable,
    KAP20Burnable
{
    constructor(
        string memory project_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint8 acceptedKycLevel_,
        address adminRouter_,
        address committee_,
        address kyc_,
        address transferRouter_,
        uint256 hardcap_
    )
        KAP20(
            project_,
            name_,
            symbol_,
            decimals_,
            acceptedKycLevel_,
            adminRouter_,
            committee_,
            kyc_,
            transferRouter_
        )
        KAP20Capped(hardcap_)
    {
        _mint(_msgSender(),100000*(10**decimals()));
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(KAP20, KAP20Blacklist) {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount)
        internal
        virtual
        override(KAP20, KAP20Capped)
    {
        super._mint(account, amount);
    }
}
