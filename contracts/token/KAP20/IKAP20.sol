// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @author <author>@bitkub.com
/// @title Revised Interface of KAP-20 Token Standard

interface IKAP20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function adminApprove(
        address owner,
        address spender,
        uint256 amount
    ) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function internalTransfer(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function externalTransfer(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function adminTransfer(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}
