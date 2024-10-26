// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IKYCBitkubChain {
    event KycChanged(address kyc_);

    event AcceptedKycLevelChanged(uint8 kycLevel);

    event OnlyKycAddressActivated();

    event OnlyKycAddressDeactived();

    function kycsLevel(address contractAddress) external view returns (uint8);
}
