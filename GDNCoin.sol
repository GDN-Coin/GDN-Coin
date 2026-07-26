// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

contract GDNCoin is ERC20, ERC20Burnable, ERC20Pausable, Ownable {
    constructor()
        ERC20("GDN Coin", "GDN")
        Ownable(msg.sender)
    {
        _mint(msg.sender, 1_000_000_000 * 10 ** decimals());
    }

    // Only the owner can stop token transfers in an emergency.
    function pause() public onlyOwner {
        _pause();
    }

    // Only the owner can restart token transfers.
    function unpause() public onlyOwner {
        _unpause();
    }

    // Required because ERC20 and ERC20Pausable both use _update().
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override(ERC20, ERC20Pausable) {
        super._update(from, to, value);
    }
}