// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IAdminProject.sol";
import "../utils/Context.sol";
import "../utils/EnumerableSetAddress.sol";

contract AdminProject is IAdminProject, Context {
    using EnumerableSetAddress for EnumerableSetAddress.AddressSet;

    bytes32 public adminChangeKey;
    address public override rootAdmin;

    mapping(address => string) public superAdminProject;
    mapping(address => string) public adminProject;

    mapping(string => EnumerableSetAddress.AddressSet)
        private _projectSuperAdmin;
    mapping(string => EnumerableSetAddress.AddressSet) private _projectAdmin;

    event RoleGranted(address indexed account, address indexed sender);
    event RoleRevoked(address indexed account, address indexed sender);

    modifier onlyRootAdmin() {
        require(
            _msgSender() == rootAdmin,
            "AdminProject: Only Root can add super admin"
        );
        _;
    }

    constructor(address _root, bytes32 _adminChangeKey) public {
        rootAdmin = _root;
        adminChangeKey = _adminChangeKey;
    }

    function verify(
        bytes32 root,
        bytes32 leaf,
        bytes32[] memory proof
    ) public pure returns (bool) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (computedHash < proofElement) {
                computedHash = keccak256(
                    abi.encodePacked(computedHash, proofElement)
                );
            } else {
                computedHash = keccak256(
                    abi.encodePacked(proofElement, computedHash)
                );
            }
        }
        return computedHash == root;
    }

    function changeRoot(
        address _newAdmin,
        bytes32 _keyData,
        bytes32[] memory merkleProof,
        bytes32 _newRootKey
    ) public {
        bytes32 leaf = keccak256(
            abi.encodePacked(_msgSender(), "BitkubAdminProject", _keyData)
        );
        require(
            verify(adminChangeKey, leaf, merkleProof),
            "AdminProject: Invalid proof."
        );
        rootAdmin = _newAdmin;
        adminChangeKey = _newRootKey;
    }

    function isSuperAdmin(address _addr, string calldata _project)
        external
        view
        override
        returns (bool)
    {
        return (keccak256(bytes(superAdminProject[_addr])) ==
            keccak256(bytes(_project)));
    }

    function isAdmin(address _addr, string calldata _project)
        external
        view
        override
        returns (bool)
    {
        return (keccak256(bytes(adminProject[_addr])) ==
            keccak256(bytes(_project)));
    }

    function addAdmin(address _addr, string calldata _project)
        external
        onlyRootAdmin
    {
        require(
            bytes(superAdminProject[_addr]).length == 0 &&
                bytes(adminProject[_addr]).length == 0,
            "AdminProject: Already set admin"
        );
        adminProject[_addr] = _project;
        _projectAdmin[_project].add(_addr);
        emit RoleGranted(_addr, _msgSender());
    }

    function revokeAdmin(address _addr, string calldata _project)
        external
        onlyRootAdmin
    {
        adminProject[_addr] = "";
        _projectAdmin[_project].remove(_addr);
        emit RoleRevoked(_addr, _msgSender());
    }

    function addSuperAdmin(address _addr, string calldata _project)
        external
        onlyRootAdmin
    {
        require(
            bytes(superAdminProject[_addr]).length == 0 &&
                bytes(adminProject[_addr]).length == 0,
            "AdminProject: Already set admin"
        );
        superAdminProject[_addr] = _project;
        _projectSuperAdmin[_project].add(_addr);
        emit RoleGranted(_addr, _msgSender());
    }

    function revokeSuperAdmin(address _addr, string calldata _project)
        external
        onlyRootAdmin
    {
        superAdminProject[_addr] = "";
        _projectSuperAdmin[_project].remove(_addr);
        emit RoleRevoked(_addr, _msgSender());
    }

    function getAdminLength(string calldata _project)
        external
        view
        returns (uint256)
    {
        return _projectAdmin[_project].length();
    }

    function getAdminProject(
        string calldata _project,
        uint256 _page,
        uint256 _limit
    ) external view returns (address[] memory) {
        return _projectAdmin[_project].get(_page, _limit);
    }

    function getSuperAdminLength(string calldata _project)
        external
        view
        returns (uint256)
    {
        return _projectSuperAdmin[_project].length();
    }

    function getSuperAdminProject(
        string calldata _project,
        uint256 _page,
        uint256 _limit
    ) external view returns (address[] memory) {
        return _projectSuperAdmin[_project].get(_page, _limit);
    }
}
