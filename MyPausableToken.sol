// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyPausableToken {
    address public owner;
    bool public paused;
    mapping(address => uint) public balances;

    constructor() {
        owner = msg.sender;
        paused = false;
        balances[owner] = 1000;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "NOT AUTHORIZED: You are not the contract owner");
        _;
    }

    modifier notPaused() {
        require(paused == false, "CONTRACT IS PAUSED: Cannot perform operation");
        _;
    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

    function transfer(address to, uint amount) public notPaused {
        require(balances[msg.sender] >= amount, "INSUFFICIENT FUNDS: Not enough for transfer");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
} 