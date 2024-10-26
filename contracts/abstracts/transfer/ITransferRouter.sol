// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITransferRouter {
    function setTransferRouter(address routerContract) external;

    function getRouterImplemetation() external view returns (address);
}
