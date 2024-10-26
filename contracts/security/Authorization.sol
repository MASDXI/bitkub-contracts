// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IAdminProject.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";

abstract contract Authorization is Context {
    IAdminProject public admin;

    string private _project;
    address private _transferRouter;

    event AdminChanged(address account);

    constructor(string memory project_, address transferRouter_) {
        _project = project_;
        _transferRouter = transferRouter_;
    }

    modifier onlySuperAdmin() {
        require(
            admin.isSuperAdmin(_msgSender(), _project),
            "Authorized: Restricted only super admin"
        );
        _;
    }

    modifier onlySuperAdminOrTransferRouter() {
        require(
            admin.isSuperAdmin(_msgSender(), _project) ||
                _msgSender() == _transferRouter,
            "Authorized:Restricted only super admin or transfer router"
        );
        _;
    }

    modifier onlySuperAdminOrAdmin() {
        require(
            admin.isSuperAdmin(_msgSender(), _project) ||
                admin.isAdmin(_msgSender(), _project),
            "Authorized: Restricted only super admin or admin"
        );
        _;
    }

    function setAdmin(address account) external onlySuperAdmin {
        require(address(admin) != account, "Authorized: already set admin");
        admin = IAdminProject(account);
        emit AdminChanged(account);
    }

    function project() public view returns (string memory) {
        return _project;
    }
}
