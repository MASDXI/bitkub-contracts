// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IKAP20 is IERC20 {
    error KAP20NotKYCUser();

    function adminTransfer(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function adminApprove(
        address owner,
        address spender,
        uint256 amount
    ) external returns (bool);
}
