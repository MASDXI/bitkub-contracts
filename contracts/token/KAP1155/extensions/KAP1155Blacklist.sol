// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../KAP1155.sol";
import "./IKAP1155Blacklist.sol";

abstract contract KAP1155Blacklist is KAP1155, IKAP1155Blacklist {
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
            "KAP1155Blacklist: can't blacklist default address"
        );
        require(
            !hasBlacklist(account),
            "KAP1155Blacklist: account must not in blacklist"
        );
        _blacklist[account] = true;
        emit BlacklistAdded(account, _msgSender());
    }

    function _revokeBlacklist(address account) internal {
        require(
            account != address(0),
            "KAP1155Blacklist: can't blacklist default address"
        );
        require(
            hasBlacklist(account),
            "KAP1155Blacklist: account must be in blacklist"
        );
        _blacklist[account] = false;
        emit BlacklistRevoked(account, _msgSender());
    }

    /**
     * @dev check is ib Blacklist before transfer token
     * @param from <type:address> sender address
     * @param to <type:address> reciepient address
     * @param amounts <type:uint256> amount of token
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);

        require(
            !hasBlacklist(from),
            "KAP1155Blacklist: from address must not in blacklist"
        );
        require(
            !hasBlacklist(to),
            "KAP1155Blacklist: to address must not in blacklist"
        );
    }
}
