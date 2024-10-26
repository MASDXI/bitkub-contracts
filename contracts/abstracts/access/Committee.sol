// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";

abstract contract Committee is Context {
    event ComitteeChanged(address committeeAddress);

    error ERROR_RESTRICTED_ONLY_COMMITTEE();
    error ERROR_INVALID_COMMITTEE_ADDRESS();

    address private _committee;

    constructor(address committee_) {
        _initializeCommittee(committee_);
    }

    modifier onlyCommittee() {
        if (_msgSender() != _committee) {
            revert ERROR_RESTRICTED_ONLY_COMMITTEE();
        }
        _;
    }

    function _initializeCommittee(address newCommittee) private {
        if (newCommittee == address(0)) {
            revert ERROR_INVALID_COMMITTEE_ADDRESS();
        }
        _updateComittee(newCommittee);
    }

    function _updateComittee(address newCommittee) private {
        _committee = newCommittee;
        emit ComitteeChanged(newCommittee);
    }

    function committee() public view returns (address) {
        return _committee;
    }

    function setCommittee(address newCommittee) external onlyCommittee {
        if (newCommittee == _committee) {
            revert ERROR_INVALID_COMMITTEE_ADDRESS();
        }
        _updateComittee(newCommittee);
    }
}
