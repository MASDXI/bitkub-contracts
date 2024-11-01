// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {KAP22} from "../KAP22.sol";
import {IKAP22Whitelist} from "./IKAP22Whitelist.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

abstract contract KAP22Whitelist is KAP22, IKAP22Whitelist {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private _whitelist;

    constructor(
        string memory projectName_,
        string memory tokenName_,
        string memory tokenSymbol_,
        uint8 acceptedKycLevel_,
        address adminRegistry_,
        address committee_,
        address kycRegistry_,
        address transferRouter_,
        address owner_,
        uint256 startTime_,
        uint256 periodLength_
    )
        KAP22(
            projectName_,
            tokenName_,
            tokenSymbol_,
            acceptedKycLevel_,
            adminRegistry_,
            committee_,
            kycRegistry_,
            transferRouter_,
            owner_,
            startTime_,
            periodLength_
        )
    {}

    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        _update(from, to, currentIndex(), value);
    }

    /// @custom:gas-inefficiency emit event multiple times when transfer from whitelist address to whitelist address
    function _update(
        address from,
        address to,
        uint256 period,
        uint256 value
    ) internal virtual override refreshPeriod {
        // modified acess to new storage from openzeppelin ERC20
        if ((isWhitelist(from) || from == owner()) && isWhitelist(to)) {
            _updatePreviosPeriod(from, to, period, value);
        } else if (from == owner()) {
            super._update(from, to, period + 1, value);
        } else {
            super._update(from, to, period, value);
        }
    }

    function balanceOf(
        address account
    ) public view override(IERC20, KAP22) returns (uint256) {
        if (isWhitelist(account)) {
            uint256 balances;
            uint256 period = currentPeriod();
            for (uint256 i = 0; i <= period + 1; i++) {
                balances += balanceOf(account, period);
            }
            return balances;
        } else {
            return super.balanceOf(account);
        }
    }

    function isWhitelist(address _addr) public view override returns (bool) {
        return _whitelist.contains(_addr);
    }

    function addWhitelistAddress(address account) public onlyOwner {
        if (account == address(0) && account == address(this)) {
            // revert  // "WhitelistAddress: invalid address"
        }
        if (!_whitelist.add(account)) {
            // revert // "WhitelistAddress: address already exists"
        }
        // emit event
    }

    function revokeWhitelistAddress(address account) public onlyOwner {
        if (!_whitelist.remove(account)) {
            // revert  // "WhitelistAddress: address does not exist"
        }
        // emit event
    }
}
