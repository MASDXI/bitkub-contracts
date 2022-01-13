// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRouter.sol";

abstract contract Router {
    IRouter private _router;

    event TransferRouterChanged(address routerContract);

    constructor(address router_) {
        _router = IRouter(router_);
    }

    function _setTransferRouter(address routerContract) internal {
        _router = IRouter(routerContract);
        emit TransferRouterChanged(address(routerContract));
    }

    function router() public view returns (address) {
        return address(_router);
    }
}
