// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../security/interface/IAdminProject.sol";
import "../utils/Context.sol";

contract AdminProjectRouter is Context {
    event AdminProjectChanged(address account);

    IAdminProject public adminProject;

    constructor(address _adminProject) public {
        adminProject = IAdminProject(_adminProject);
    }

    modifier onlyRootAdmin() {
        require(
            adminProject.rootAdmin() == _msgSender(),
            "AdminProjectRouter: Restricted only root admin"
        );
        _;
    }

    function isSuperAdmin(address _addr, string calldata _project)
        external
        view
        returns (bool)
    {
        return adminProject.isSuperAdmin(_addr, _project);
    }

    function isAdmin(address _addr, string calldata _project)
        external
        view
        returns (bool)
    {
        return adminProject.isAdmin(_addr, _project);
    }

    function setAdminProject(address _adminProject)
        external
        onlyRootAdmin
        returns (bool)
    {
        require(address(adminProject) != _adminProject, "AdminProjectRouter:");
        adminProject = IAdminProject(_adminProject);
        emit AdminProjectChanged(_adminProject);
        return true;
    }
}
