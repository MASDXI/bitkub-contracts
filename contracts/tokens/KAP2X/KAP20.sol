// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IKAP20} from "./IKAP20.sol";
import {IKAP20TransferRouter} from "./extensions/IKAP20TransferRouter.sol";
import {ProjectAccessController } from "../../abstracts/ProjectAccessController.sol";
// import {TransferRouter} from "../../abastracts/TransferRouter.sol;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

abstract contract KAP20 is
    ProjectAccessController ,
    ERC20,
    IKAP20,
    IKAP20TransferRouter,
    Pausable,
    Ownable
{
    constructor(
        string memory projectName_,
        string memory tokenName_,
        string memory tokenSymbol_,
        uint8 acceptedKycLevel_,
        address adminRegistry_,
        address committee_,
        address kycRegistry_,
        address transferRouter_,
        address owner_
    )
        ProjectAccessController(projectName_, acceptedKycLevel_, adminRegistry_, committee_, kycRegistry_, transferRouter_)
        ERC20(tokenName_, tokenSymbol_)
        Ownable(owner_)
    {}

    function _isNotKYCUser(
        address from,
        address to
    ) internal view returns (bool) {
        uint8 acceptedLevelCache = _getAcceptedKycLevel();
        if (
            kyc().kycsLevel(from) < acceptedLevelCache ||
            kyc().kycsLevel(to) < acceptedLevelCache
        ) {
            return true;
        }
    }

    function adminApprove(
        address owner,
        address spender,
        uint256 amount
    ) external override onlySuperAdminOrAdmin returns (bool) {
        if (_isNotKYCUser(owner, spender)) {
            revert KAP20NotKYCUser();
        }
        _approve(owner, spender, amount);
        return true;
    }

    function adminTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) external override onlyCommittee returns (bool) {
        _transfer(sender, recipient, amount);
        return true;
    }

    function internalTransfer(
        address from,
        address to,
        uint256 amount
    )
        external
        override
        whenNotPaused
        onlySuperAdminOrTransferRouter
        returns (bool)
    {
        if (_isNotKYCUser(from, to)) {
            revert KAP20OnlyInternalPurpose();
        }
        _transfer(from, to, amount);
        return true;
    }

    function externalTransfer(
        address from,
        address to,
        uint256 amount
    )
        external
        override
        whenNotPaused
        onlySuperAdminOrTransferRouter
        returns (bool)
    {
        if (kyc().kycsLevel(from) < _getAcceptedKycLevel()) {
            revert KAP20OnlyExternalPurpose();
        }
        _transfer(from, to, amount);
        return true;
    }

    function pause() public onlyCommittee {
        _pause();
    }

    function unpause() public onlyCommittee {
        _unpause();
    }
}
