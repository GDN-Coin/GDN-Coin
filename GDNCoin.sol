// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable2Step.sol";

/**
 * @title GDN Coin
 * @author GDN Ecosystem
 * @notice Fixed-supply ERC-20 token for the GDN Ecosystem.
 * @dev
 * - Total supply is created once during deployment.
 * - 95% is allocated to the treasury wallet.
 * - 5% is allocated to the charity reserve wallet.
 * - No transfer tax is applied.
 * - No additional minting function exists.
 * - Token transfers may be paused by the owner in an emergency.
 */
contract GDNCoin is
    ERC20,
    ERC20Burnable,
    ERC20Pausable,
    Ownable2Step
{
    /// @notice Reverts when a required wallet is the zero address.
    error ZeroAddress();

    /// @notice Reverts when treasury and charity wallets are identical.
    error IdenticalWalletAddresses();

    /// @notice Total fixed supply of GDN, including 18 decimal places.
    uint256 public constant TOTAL_SUPPLY =
        1_000_000_000 * 10 ** 18;

    /// @notice Treasury allocation: 95% of the total supply.
    uint256 public constant TREASURY_SUPPLY =
        950_000_000 * 10 ** 18;

    /// @notice Charity reserve allocation: 5% of the total supply.
    uint256 public constant CHARITY_SUPPLY =
        50_000_000 * 10 ** 18;

    /// @notice Wallet receiving the treasury allocation.
    address public immutable treasuryWallet;

    /// @notice Wallet receiving the charity reserve allocation.
    address public immutable charityReserveWallet;

    /**
     * @notice Emitted when the initial fixed supply is distributed.
     * @param treasuryWallet Address receiving the treasury allocation.
     * @param treasuryAmount Amount allocated to the treasury.
     * @param charityReserveWallet Address receiving the charity allocation.
     * @param charityAmount Amount allocated to the charity reserve.
     */
    event InitialDistribution(
        address indexed treasuryWallet,
        uint256 treasuryAmount,
        address indexed charityReserveWallet,
        uint256 charityAmount
    );

    /**
     * @notice Creates GDN Coin and distributes the entire fixed supply.
     * @param treasuryWallet_ Address receiving 950,000,000 GDN.
     * @param charityReserveWallet_ Address receiving 50,000,000 GDN.
     */
    constructor(
        address treasuryWallet_,
        address charityReserveWallet_
    )
        ERC20("GDN Coin", "GDN")
        Ownable(msg.sender)
    {
        if (
            treasuryWallet_ == address(0) ||
            charityReserveWallet_ == address(0)
        ) {
            revert ZeroAddress();
        }

        if (treasuryWallet_ == charityReserveWallet_) {
            revert IdenticalWalletAddresses();
        }

        treasuryWallet = treasuryWallet_;
        charityReserveWallet = charityReserveWallet_;

        _mint(treasuryWallet_, TREASURY_SUPPLY);
        _mint(charityReserveWallet_, CHARITY_SUPPLY);

        emit InitialDistribution(
            treasuryWallet_,
            TREASURY_SUPPLY,
            charityReserveWallet_,
            CHARITY_SUPPLY
        );
    }

    /**
     * @notice Pauses transfers, minting and burning.
     * @dev Can only be called by the current owner.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @notice Restarts token transfers and burning.
     * @dev Can only be called by the current owner.
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev Applies the ERC20Pausable transfer restrictions.
     */
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
