// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IKAP20.sol";
import "./extensions/IKAP20Metadata.sol";
import "../../security/Authorization.sol";
import "../../security/Committee.sol";
import "../../security/KYCHandler.sol";
import "../../security/Pausable.sol";
// not sure is router is mendatory or not in KAP20
import "../../router/Router.sol";

contract KAP20 is
    Authorization,
    Committee,
    IKAP20,
    IKAP20Metadata,
    KYCHandler,
    Pausable,
    Router
{
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(
        string memory project_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint8 acceptedKycLevel_,
        address adminRouter_,
        address committee_,
        address kyc_,
        address transferRouter_
    )
        Authorization(project_, adminRouter_)
        KYCHandler(kyc_, acceptedKycLevel_)
        Committee(committee_)
        Router(transferRouter_)
    {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        whenNotPaused
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "KAP20: transfer amount exceeds allowance"
            );
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        _transfer(sender, recipient, amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "KAP20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "KAP20: transfer from the zero address");
        require(recipient != address(0), "KAP20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "KAP20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "KAP20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "KAP20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "KAP20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "KAP20: approve from the zero address");
        require(spender != address(0), "KAP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function adminApprove(
        address owner,
        address spender,
        uint256 amount
    ) external override onlySuperAdminOrAdmin returns (bool) {
        require(
            kyc().kycsLevel(owner) >= acceptedKycLevel,
            "KAP20: Owner address is not a KYC user"
        );
        require(
            kyc().kycsLevel(spender) >= acceptedKycLevel,
            "KAP20: Spender address is not a KYC user"
        );

        _approve(owner, spender, amount);
        return true;
    }

    function internalTransfer(
        address from,
        address to,
        uint256 amount
    )
        external
        override
        whenNotPaused
        onlySuperAdminOrTransferRouter
        returns (bool)
    {
        require(
            kyc().kycsLevel(from) >= acceptedKycLevel,
            "KAP20: Sender address is not a KYC user"
        );
        require(
            kyc().kycsLevel(to) >= acceptedKycLevel,
            "KAP20: Recipient address is not a KYC user"
        );

        _transfer(from, to, amount);
        return true;
    }

    function externalTransfer(
        address from,
        address to,
        uint256 amount
    )
        external
        override
        whenNotPaused
        onlySuperAdminOrTransferRouter
        returns (bool)
    {
        require(
            kyc().kycsLevel(from) >= acceptedKycLevel,
            "KAP20: Sender address is not a KYC user"
        );

        _transfer(from, to, amount);
        return true;
    }

    function adminTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) external override onlyCommittee returns (bool) {
        _transfer(sender, recipient, amount);
        return true;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function pause() public onlyCommittee {
        _pause();
    }

    function unpause() public onlyCommittee {
        _unpause();
    }

    // #############################################################################################################################

    function setTransferRouter(address transferRouter) external onlyCommittee {
        _setTransferRouter(transferRouter);
    }

    function activateOnlyKycAddress() external onlyCommittee {
        _activateOnlyKycAddress();
    }

    function setKYC(address kycContract) external onlyCommittee {
        _setKYC(kycContract);
    }

    function setAcceptedKycLevel(uint8 kycLevel) external onlyCommittee {
        _setAcceptedKycLevel(kycLevel);
    }

    // #############################################################################################################################
}
