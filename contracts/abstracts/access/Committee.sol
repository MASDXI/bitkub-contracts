// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";

abstract contract Committee is Context {
    event ComitteeChanged(address committeeAddress);

    address private _committee;

    constructor(address committeeAddress) {
        _committee = committeeAddress;
    }

    modifier onlyCommittee() {
        require(
            _msgSender() == _committee,
            "Committee: Restricted only committee"
        );
        _;
    }

    function setCommittee(address committeeAddress) external onlyCommittee {
        require(
            _committee != committeeAddress,
            "Committee: can't set exist committee address"
        );
        _committee = committeeAddress;
        emit ComitteeChanged(committeeAddress);
    }

    function committee() public view returns (address) {
        return _committee;
    }
}
