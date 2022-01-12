// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interface/IKYCBitkubChain.sol";

abstract contract KYCHandler {
    IKYCBitkubChain private _kyc;

    uint8 public acceptedKycLevel;
    bool public isActivatedOnlyKycAddress;

    constructor(IKYCBitkubChain kyc_, uint8 acceptedKycLevel_) {
        _kyc = kyc_;
        acceptedKycLevel = acceptedKycLevel_;
    }

    function _activateOnlyKycAddress() internal virtual {
        isActivatedOnlyKycAddress = true;
    }

    function _deactivateOnlyKycAddress() internal virtual {
        isActivatedOnlyKycAddress = false;
    }

    function _setKYC(IKYCBitkubChain kyc) internal virtual {
        _kyc = kyc;
    }

    function _setAcceptedKycLevel(uint8 kycLevel) internal virtual {
        acceptedKycLevel = kycLevel;
    }

    function kycImplemetation() public view returns (IKYCBitkubChain) {
        return _kyc;
    }
}
