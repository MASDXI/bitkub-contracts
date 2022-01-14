// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICommittee {
    event ComitteeChanged(address committeeAddress);

    function setCommittee(address committeeAddress) external;

    function committee() external view returns (address);
}