// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IAdminProject} from "./interfaces/IAdminProject.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";

abstract contract Administrator is Context {
    string private _project;
    address private _transferRouter;
    IAdminProject private _admin;

    event AdminChanged(address account);
    // event

    error ERROR_RESTRICTED_ONLY_ADMIN();
    error ERROR_RESTRICTED_ONLY_SUPER_ADMIN();
    error ERROR_RESTRICTED_ONLY_SUPER_ADMIN_OR_ADMIN();
    error ERROR_RESTRICTED_ONLY_SUPER_ADMIN_OR_TRANSFER_ROUTER();
    error ERROR_INVALID_ADMIN_ADDRESS();

    constructor(
        string memory project_,
        address transferRouter_,
        address admin_
    ) {
        _project = project_;
        _transferRouter = transferRouter_;
        _initializeAdmin(admin_);
    }

    modifier onlyAdmin() {
        if (_admin.isAdmin(_msgSender(), _project)) {
            _;
        } else {
            revert ERROR_RESTRICTED_ONLY_ADMIN();
        }
    }

    modifier onlySuperAdmin() {
        if (_admin.isSuperAdmin(_msgSender(), _project)) {
            _;
        } else {
            revert ERROR_RESTRICTED_ONLY_SUPER_ADMIN();
        }
    }

    modifier onlySuperAdminOrAdmin() {
        if (
            _admin.isSuperAdmin(_msgSender(), _project) ||
            _admin.isAdmin(_msgSender(), _project)
        ) {
            _;
        } else {
            revert ERROR_RESTRICTED_ONLY_SUPER_ADMIN_OR_ADMIN();
        }
    }

    modifier onlySuperAdminOrTransferRouter() {
        if (
            _admin.isSuperAdmin(_msgSender(), _project) ||
            _msgSender() == address(_transferRouter)
        ) {
            _;
        } else {
            revert ERROR_RESTRICTED_ONLY_SUPER_ADMIN_OR_TRANSFER_ROUTER();
        }
    }

    function _initializeAdmin(address account) private {
        if (account == address(0)) {
            revert ERROR_INVALID_ADMIN_ADDRESS();
        }
        _updateAdmin(account);
    }

    function _updateAdmin(address account) private {
        _admin = IAdminProject(account);
        emit AdminChanged(account);
    }

    function setAdmin(address account) external onlySuperAdmin {
        if (address(_admin) == account) {
            revert ERROR_INVALID_ADMIN_ADDRESS();
        }
        _updateAdmin(account);
    }

    function project() public view returns (string memory) {
        return _project;
    }

    function transferRouter() public view returns (address) {
        return _transferRouter;
    }
}
