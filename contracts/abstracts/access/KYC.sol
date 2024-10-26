// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IKYCBitkubChain as IKYC} from "./interfaces/IKYCBitkubChain.sol";

abstract contract KYC {
    IKYC private _kyc;

    uint8 private _acceptedKycLevel;
    bool public isActivatedOnlyKycAddress;

    constructor(address kyc_, uint8 acceptedKycLevel_) {
        _kyc = IKYC(kyc_);
        _acceptedKycLevel = acceptedKycLevel_;
    }

    function _getAcceptedKycLevel() internal view returns (uint8) {
        return _acceptedKycLevel;
    }

    function _activateOnlyKycAddress() internal virtual {
        isActivatedOnlyKycAddress = true;
        // emit OnlyKycAddressActivated();
    }

    function _deactivateOnlyKycAddress() internal virtual {
        isActivatedOnlyKycAddress = false;
        // emit OnlyKycAddressDeactived();
    }

    function _setKYC(address kyc_) internal virtual {
        _kyc = IKYC(kyc_);
        // emit KycChanged(kyc_);
    }

    function _setAcceptedKycLevel(uint8 kycLevel) internal virtual {
        _acceptedKycLevel = kycLevel;
        // emit AcceptedKycLevelChanged(kycLevel);
    }

    function kyc() public view returns (IKYC) {
        return _kyc;
    }
}
