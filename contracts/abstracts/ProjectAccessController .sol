// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/// @title ProjectAccessController Contract
/// @notice Consolidates all access-related functionality into a single contract, 
///         avoiding complex or invalid inheritance hierarchies.

import {IAdminProject as IAdminRegistry} from "./interfaces/IAdminProject.sol";
import {IKYCBitkubChain as IKYCRegistry} from "./interfaces/IKYCBitkubChain.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";

abstract contract ProjectAccessController is Context {
    address private _committee;
    address private _transferRouter;
    IAdminRegistry private _adminRegistry;
    IKYCRegistry private _kycRegistry;
    string private _project;
    uint8 private _acceptedKycLevel;
    bool private _isActivatedOnlyKycAddress;

    event AdminChanged(address admin);
    event CommitteeChanged(address committee);
    event KycChanged(address kyc);
    event AcceptedKycLevelChanged(uint8 kyclevel);

    error RestrictedOnlyAdmin();
    error RestrictedOnlyCommittee();
    error RestrictedOnlySuperAdmin();
    error RestrictedOnlySuperAdminOrAdmin();
    error RestrictedOnlySuperAdminOrTransferRouter();
    error InvalidAdminAddress();
    error InvalidCommiteeAddress();
    error InvalidRouterAddress();

    constructor(
        string memory project_,
        address adminRegsitry_,
        address committee_,
        address kycRegistry_,
        address transferRouter_
    ) {
        _project = project_;
        _adminRegistry = IAdminRegistry(adminRegsitry_);
        _committee = committee_;
        _kycRegistry = IKYCRegistry(kycRegistry_);
        _transferRouter = transferRouter_;
    }

    modifier onlyCommittee() {
        if (_msgSender() == _committee) {
            _;
        } else {
            revert InvalidCommiteeAddress();
        }
    }

    modifier onlyAdmin() {
        if (_adminRegistry.isAdmin(_msgSender(), _project)) {
            _;
        } else {
            revert RestrictedOnlyAdmin();
        }
    }

    modifier onlySuperAdmin() {
        if (_adminRegistry.isSuperAdmin(_msgSender(), _project)) {
            _;
        } else {
            revert RestrictedOnlySuperAdmin();
        }
    }

    modifier onlySuperAdminOrAdmin() {
        if (
            _adminRegistry.isSuperAdmin(_msgSender(), _project) ||
            _adminRegistry.isAdmin(_msgSender(), _project)
        ) {
            _;
        } else {
            revert RestrictedOnlySuperAdminOrAdmin();
        }
    }

    modifier onlySuperAdminOrTransferRouter() {
        if (
            _adminRegistry.isSuperAdmin(_msgSender(), _project) ||
            _msgSender() == address(_transferRouter)
        ) {
            _;
        } else {
            revert RestrictedOnlySuperAdminOrTransferRouter();
        }
    }

    function setAdmin(address account) external onlySuperAdmin {
        if (address(_adminRegistry) == account) {
            revert InvalidAdminAddress();
        }
        _adminRegistry = IAdminRegistry(account);
        emit AdminChanged(account);
    }

    function committee() public view returns (address) {
        return _committee;
    }

    function setCommittee(address newCommittee) external onlyCommittee {
        if (newCommittee == _committee) {
            revert InvalidCommiteeAddress();
        }
        _committee = newCommittee;
        emit CommitteeChanged(newCommittee);
    }

    function _getAcceptedKycLevel() internal view returns (uint8) {
        return _acceptedKycLevel;
    }

    function activateOnlyKycAddress() public onlyCommittee {
        _isActivatedOnlyKycAddress = true;
        // emit OnlyKycAddressActivated();
    }

    function deactivateOnlyKycAddress() public onlyCommittee {
        _isActivatedOnlyKycAddress = false;
        // emit OnlyKycAddressDeactived();
    }

    function setKYCRegistry(address kyc) public onlyCommittee {
        _kycRegistry = IKYCRegistry(kyc);
        // emit KycChanged(kyc_);
    }

    function setAcceptedKycLevel(uint8 kycLevel) public onlyCommittee() {
        _acceptedKycLevel = kycLevel;
        // emit AcceptedKycLevelChanged(kycLevel);
    }

    function setTransferRouter(address transferRouter) external onlyCommittee {
        _transferRouter = transferRouter;
        // emit TransferRouterChanged(transferRouter);
    }

    function kyc() public view returns (IKYCRegistry) {
        return _kycRegistry;
    }

    function project() public view returns (string memory) {
        return _project;
    }

    function transferRouter() public view returns (address) {
        return _transferRouter;
    }

    function adminRegsitry() public view returns (IAdminRegistry) {
        return _adminRegistry;
    }
}
