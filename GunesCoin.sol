// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable2Step.sol";

/**
 * @title Gunes Coin
 * @author Gunes Coin Ecosystem
 * @notice Fixed-supply ERC-20 token for the Gunes Coin Ecosystem.
 *
 * Total Supply: 1,000,000,000 GUNES
 * Treasury: 95%
 * Charity Reserve: 5%
 * Transfer Tax: 0%
 */
contract GunesCoin is
    ERC20,
    ERC20Burnable,
    ERC20Pausable,
    Ownable2Step
{
    error ZeroAddress();
    error IdenticalWalletAddresses();

    uint256 public constant TOTAL_SUPPLY =
        1_000_000_000 * 10 ** 18;

    uint256 public constant TREASURY_SUPPLY =
        950_000_000 * 10 ** 18;

    uint256 public constant CHARITY_SUPPLY =
        50_000_000 * 10 ** 18;

    address public immutable treasuryWallet;
    address public immutable charityReserveWallet;

    event InitialDistribution(
        address indexed treasuryWallet,
        uint256 treasuryAmount,
        address indexed charityReserveWallet,
        uint256 charityAmount
    );

    constructor(
        address treasuryWallet_,
        address charityReserveWallet_
    )
        ERC20("Gunes Coin", "GUNES")
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

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

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