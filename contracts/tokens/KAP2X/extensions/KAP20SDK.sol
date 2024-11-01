// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {KAP20} from "../KAP20.sol";
import {IKAP20SDK} from "./IKAP20SDK.sol";

abstract contract KAP20SDK is KAP20, IKAP20SDK {
    address private _executor;

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
        address executor_
    )
        KAP20(
            projectName_,
            tokenName_,
            tokenSymbol_,
            acceptedKycLevel_,
            adminRegistry_,
            committee_,
            kycRegistry_,
            transferRouter_,
            owner_
        )
    {
        _executor = executor_;
    }

    modifier onlyExecutor() {
        if (_msgSender() == _executor) {
            _;
        } else {
            revert KAP20SDKRestrictedOnlyExecutor();
        }
    }

    function approveBySDK(
        address owner,
        address spender,
        uint256 amount
    ) external override onlyExecutor returns (bool) {
        _approve(owner, spender, amount);
        return true;
    }

    function transferFromBySDK(
        address from,
        address to,
        uint256 amount
    ) external override onlyExecutor returns (bool) {
        if (_isNotKYCUser(from, to)) {
            revert KAP20OnlyInternalPurpose();
        }
        _transfer(from, to, amount);
        return true;
    }
}
