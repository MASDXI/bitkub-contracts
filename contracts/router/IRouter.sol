// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRouter {
    function setTransferRouter(address routerContract) external;

    function getRouterImplemetation() external view returns (address);
}
