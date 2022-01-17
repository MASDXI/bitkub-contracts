// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IKAP721Blacklist.sol";
import "../KAP721.sol";

abstract contract KAP721Blacklist is KAP721, IKAP721Blacklist {
    mapping(address => bool) private _blacklist;

    function hasBlacklist(address account) public view override returns (bool) {
        return _blacklist[account];
    }

    function addBlacklist(address account)
        external
        virtual
        override
        returns (bool)
    {
        _addBlacklist(account);
        return true;
    }

    function revokeBlacklist(address account)
        external
        virtual
        override
        returns (bool)
    {
        _revokeBlacklist(account);
        return true;
    }

    function _addBlacklist(address account) internal {
        require(
            account != address(0),
            "KAP721Blacklist: can't blacklist deafult address"
        );
        require(
            !hasBlacklist(account),
            "KAP721Blacklist: account must not in blacklist"
        );
        _blacklist[account] = true;
        emit BlacklistAdded(account, _msgSender());
    }

    function _revokeBlacklist(address account) internal {
        require(
            account != address(0),
            "KAP721Blacklist: can't blacklist deafult address"
        );
        require(
            hasBlacklist(account),
            "KAP721Blacklist: account must be in blacklist"
        );
        _blacklist[account] = false;
        emit BlacklistRevoked(account, _msgSender());
    }

    /**
     * @dev check is ib Blacklist before transfer token
     * @param from <type:address> sender address
     * @param to <type:address> reciepient address
     * @param amount <type:uint256> amount of token
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        require(
            !hasBlacklist(from),
            "KAP721Blacklist: from address must not in blacklist"
        );
        require(
            !hasBlacklist(to),
            "KAP721Blacklist: to address must not in blacklist"
        );
    }
}