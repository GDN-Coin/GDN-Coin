// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable2Step.sol";

contract GDNCoin is
    ERC20,
    ERC20Burnable,
    ERC20Pausable,
    Ownable2Step
{
    uint256 public constant TOTAL_SUPPLY =
        1_000_000_000 * 10 ** 18;

    uint256 public constant CHARITY_PERCENTAGE = 5;

    address public immutable treasuryWallet;
    address public immutable charityReserveWallet;

    event InitialDistribution(
        address indexed treasuryWallet,
        uint256 treasuryAmount,
        address indexed charityReserveWallet,
        uint256 charityAmount
    );

    constructor(
        address _treasuryWallet,
        address _charityReserveWallet
    )
        ERC20("GDN Coin", "GDN")
        Ownable(msg.sender)
    {
        require(
            _treasuryWallet != address(0),
            "Treasury wallet cannot be zero address"
        );

        require(
            _charityReserveWallet != address(0),
            "Charity wallet cannot be zero address"
        );

        require(
            _treasuryWallet != _charityReserveWallet,
            "Wallet addresses must be different"
        );

        treasuryWallet = _treasuryWallet;
        charityReserveWallet = _charityReserveWallet;

        uint256 charityAmount =
            (TOTAL_SUPPLY * CHARITY_PERCENTAGE) / 100;

        uint256 treasuryAmount =
            TOTAL_SUPPLY - charityAmount;

        _mint(_treasuryWallet, treasuryAmount);
        _mint(_charityReserveWallet, charityAmount);

        emit InitialDistribution(
            _treasuryWallet,
            treasuryAmount,
            _charityReserveWallet,
            charityAmount
        );
    }

    // Only the owner can pause token transfers in an emergency.
    function pause() public onlyOwner {
        _pause();
    }

    // Only the owner can restart token transfers.
    function unpause() public onlyOwner {
        _unpause();
    }

    // Required by ERC20Pausable.
    function _update(
        address from,
        address to,
        uint256 value
    )
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}
