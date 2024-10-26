// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IKAP20} from "./IKAP20.sol";
import {IKAP20TransferRouter} from "./extensions/IKAP20TransferRouter.sol";
import {Authorization} from "../../abstracts/access/Authorization.sol";
import {Committee} from "../../abstracts/access/Committee.sol";
import {KYCHandler} from "../../abstracts/access/KYCHandler.sol";
import {TransferRouter} from "../../abstracts/transfer/TransferRouter.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

abstract contract KAP20 is
    Authorization,
    Committee,
    ERC20,
    KYCHandler,
    Pausable,
    Router,
    IKAP20,
    IKAP20TransferRouter
{
    constructor(
        string memory project_,
        string memory name_,
        string memory symbol_,
        uint8 acceptedKycLevel_,
        address adminRouter_,
        address committee_,
        address kyc_,
        address transferRouter_
    )
        Authorization(project_, adminRouter_)
        KYCHandler(kyc_, acceptedKycLevel_)
        Committee(committee_)
        Router(transferRouter_)
        ERC20(name_, symbol_)
    {}

    function adminApprove(
        address owner,
        address spender,
        uint256 amount
    ) external override onlySuperAdminOrAdmin returns (bool) {
        require(
            kyc().kycsLevel(owner) >= acceptedKycLevel,
            "KAP20: Owner address is not a KYC user"
        );
        require(
            kyc().kycsLevel(spender) >= acceptedKycLevel,
            "KAP20: Spender address is not a KYC user"
        );

        _approve(owner, spender, amount);
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
        require(
            kyc().kycsLevel(from) >= acceptedKycLevel,
            "KAP20: Sender address is not a KYC user"
        );
        require(
            kyc().kycsLevel(to) >= acceptedKycLevel,
            "KAP20: Recipient address is not a KYC user"
        );

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
        require(
            kyc().kycsLevel(from) >= acceptedKycLevel,
            "KAP20: Sender address is not a KYC user"
        );

        _transfer(from, to, amount);
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

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function pause() public onlyCommittee {
        _pause();
    }

    function unpause() public onlyCommittee {
        _unpause();
    }

    // #############################################################################################################################

    function setTransferRouter(address transferRouter) external onlyCommittee {
        _setTransferRouter(transferRouter);
    }

    function activateOnlyKycAddress() external onlyCommittee {
        _activateOnlyKycAddress();
    }

    function setKYC(address kycContract) external onlyCommittee {
        _setKYC(kycContract);
    }

    function setAcceptedKycLevel(uint8 kycLevel) external onlyCommittee {
        _setAcceptedKycLevel(kycLevel);
    }

    // #############################################################################################################################
}
