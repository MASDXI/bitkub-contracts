// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IKYCBitkubChain.sol";

abstract contract KYCHandler {
    IKYCBitkubChain private _kyc;

    uint8 public acceptedKycLevel;
    bool public isActivatedOnlyKycAddress;

    constructor(address kyc_, uint8 acceptedKycLevel_) {
        _kyc = IKYCBitkubChain(kyc_);
        acceptedKycLevel = acceptedKycLevel_;
    }

    function _activateOnlyKycAddress() internal virtual {
        isActivatedOnlyKycAddress = true;
    }

    function _deactivateOnlyKycAddress() internal virtual {
        isActivatedOnlyKycAddress = false;
    }

    function _setKYC(address kyc_) internal virtual {
        _kyc = IKYCBitkubChain(kyc_);
    }

    function _setAcceptedKycLevel(uint8 kycLevel) internal virtual {
        acceptedKycLevel = kycLevel;
    }

    function kyc() public view returns (IKYCBitkubChain) {
        return _kyc;
    }
}
