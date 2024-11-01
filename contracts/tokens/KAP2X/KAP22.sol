// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/// @notice this contract revised/refactor version form original smart contract code
/// https://testnet.bkcscan.com/address/0xAB590a38902Fc186120Ff18Ed4106e53B9C481a5?tab=contract

/// @custom:observation
/// asset intergrity due to relies on `block.timestamp`. If the network halts, balances will expire,
/// making this unsuitable for Layer 2 (L2) networks where `block.timestamp` returns the Layer 1 (L1) network timestamp.
/// asset intergrity If `currentIndex` is not updated, all balances within the same period will expire on the same date.
/// potential create gas griefing `_currentPeriod` and `_updatePeriod` may create a heavy loop if the period duration is too short.
/// Example scenario:
/// - Alice receives 10 tokens from a merchant at the start of the period, allowing full usability of tokens until the period changes.
/// - Bob receives 10 tokens just before the period changes (e.g., within 100 blocks), resulting in a shorter usability period compared to Alice.
///
/// Timing of token receipt and benefit impact:
/// ─────────────────────────────────────────────────────────
/// | Early in period    | Full benefits                    |
/// |────────────────────|──────────────────────────────────|
/// | Mid-period         | Partial benefits                 |
/// |────────────────────|──────────────────────────────────|
/// | Near period change | Reduced benefits                 |
/// ─────────────────────────────────────────────────────────

import {IKAP20} from "./IKAP20.sol"; // adminTransfer, adminApporve
import {IKAP22} from "./extensions/IKAP22.sol";
import {IKAP20TransferRouter} from "./extensions/IKAP20TransferRouter.sol"; // internalTransfer, externalTransfer
import {ProjectAccessController} from "../../abstracts/ProjectAccessController.sol"; // admin, superadmin, committee
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

abstract contract KAP22 is
    ProjectAccessController,
    IERC20,
    ERC20,
    IKAP20,
    IKAP22,
    IKAP20TransferRouter,
    Pausable,
    Ownable
{
    uint256 private _totalSupply;

    uint256 private _currentIndex;
    uint256 private _startTime;
    uint256 private _periodLength;
    mapping(address => mapping(uint256 => uint256)) private _balances;

    constructor(
        string memory projectName_,
        string memory tokenName_,
        string memory tokenSymbol_,
        uint8 acceptedKycLevel_,
        address adminRegistry_,
        address committee_,
        address kycRegistry_,
        address transferRouter_,
        address owner_,
        uint256 startTime_, // for KAP22
        uint256 periodLength_ // for KAP22
    )
        ProjectAccessController(
            projectName_,
            acceptedKycLevel_,
            adminRegistry_,
            committee_,
            kycRegistry_,
            transferRouter_
        )
        ERC20(tokenName_, tokenSymbol_)
        Ownable(owner_)
    {
        _startTime = startTime_;
        _periodLength = periodLength_;
    }

    modifier refreshPeriod() {
        _updatePeriod();
        _;
    }

    function _updatePeriod() internal {
        _currentIndex = _calculatePeriod();
    }

    function _calculatePeriod() internal view returns (uint256) {
        uint256 period = _currentIndex;
        while (block.timestamp > (period * _periodLength) + _startTime) {
            period++;
        }
        return period;
    }

    /// @notice before performing any action that mutates the state, `refreshPeriod` must be called.
    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override(ERC20) refreshPeriod {
        _update(from, to, _currentIndex, value);
    }

    /// @custom:observation
    /// receiving tokens close to a period change may result in a loss of benefits.
    /// this is likely to occur in all scenarios, even when the period length is short.
    function _update(
        address from,
        address to,
        uint256 period,
        uint256 value
    ) internal virtual refreshPeriod {
        // modified acess to new storage from openzeppelin ERC20
        if (from == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from][period];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                // Overflow not possible: value <= fromBalance <= totalSupply.
                _balances[from][period] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
                _totalSupply -= value;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
                _balances[to][period] += value;
            }
        }
        emit Transfer(from, to, value);
    }

    /// @custom:obersbvation it's take loop before knowing will be revert at first
    function _updatePreviousPeriod(
        address from,
        address to,
        uint256 value,
        uint256 period
    ) internal refreshPeriod {
        uint256 remainingToTransfer = value;
        uint256 valueToTransfer;
        for (; period <= _currentIndex; period++) {
            if (_balances[from][period] > remainingToTransfer) {
                valueToTransfer = remainingToTransfer;
            }

            _balances[from][period] -= valueToTransfer;
            _balances[to][period] += valueToTransfer;

            remainingToTransfer -= valueToTransfer;

            if (remainingToTransfer == 0) {
                break;
            }
        }
        if (remainingToTransfer > 0) {
            revert ERC20InsufficientBalance(from, valueToTransfer, value);
        }

        emit Transfer(from, to, value);
    }

    function _transfer(
        address from,
        address to,
        uint256 period,
        uint256 value
    ) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, period, value);
    }

    function _mint(address account, uint256 period, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, period, value);
    }

    function _burn(address account, uint256 period, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), period, value);
    }

    function balanceOf(
        address account
    ) public view virtual override(ERC20, IERC20) returns (uint256) {
        uint256 period = _calculatePeriod();
        return (_balances[account][period] + _balances[account][period + 1]);
    }

    function balanceOf(
        address account,
        uint256 period
    ) public view virtual returns (uint256) {
        return _balances[account][period];
    }

    function transferFrom(
        address from,
        address to,
        uint256 period,
        uint256 value
    ) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, period, value);
        return true;
    }

    function adminTransferPreviousPeriod(
        address from,
        address to,
        uint256 period,
        uint256 value
    ) public virtual returns (bool) {
        _updatePreviousPeriod(from, to, value, period);
        return true;
    }

    function updatePeriodNow() external virtual {
        _updatePeriod();
    }

    function currentIndex() public view override returns (uint256) {
        return _currentIndex;
    }

    function currentPeriod() public view override returns (uint256) {
        return _calculatePeriod();
    }

    function startTime() public view override returns (uint256) {
        return _startTime;
    }

    function periodLength() public view override returns (uint256) {
        return _periodLength;
    }

    // @TODO
    // interanalTransfer
    // externalTransfer
}
