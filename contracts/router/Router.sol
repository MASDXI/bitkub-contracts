// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IRouter.sol";

abstract contract Router {
    IRouter private _router;

    event TransferRouterChanged(address routerContract);

    constructor(IRouter router_) {
        _router = router_;
    }

    function _setTransferRouter(IRouter routerContract) internal {
        _router = routerContract;
        emit TransferRouterChanged(address(routerContract));
    }

    function getRouterImplemetation() public view returns (address) {
        return address(_router);
    }
}
