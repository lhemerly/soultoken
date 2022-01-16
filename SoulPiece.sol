// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SoulPiece is ERC20, Ownable {

    uint antiBotSeconds = 10;
    bool antiBot = true;

    mapping (address=>uint) public lastTrade;
    mapping (address=>bool) public whitelist;

    event setAntiBotStatus(bool status);
    event setAntiBotSeconds(uint _seconds);

    constructor() ERC20("Soul Piece", "SOUL") {
        _mint(msg.sender, 500000000 * 10 ** decimals());
        whitelist[msg.sender] = true;
    }

    function toogleAntiBot() external onlyOwner{
        antiBot = !antiBot;
        emit setAntiBotStatus(antiBot);
    }

    function setAntiBotSecs(uint seconds_) external onlyOwner{
        antiBotSeconds = seconds_;
        emit setAntiBotSeconds(antiBotSeconds);
    }

    function setWhitelist(address who) external onlyOwner{
        whitelist[who] = !whitelist[who];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (!whitelist[msg.sender]){
            uint secondsPassed = block.timestamp - lastTrade[msg.sender];
            require(secondsPassed >= antiBotSeconds, "AntiBot: You can't trade yet.");
        }
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        lastTrade[msg.sender] = block.timestamp;
    }

}