// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface IERC20 {
    // ERC-20 Methods:
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    // ERC-20 Events:
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract MyERC20 is IERC20 {
    // Implementation of interface...

    string public constant name = "MyERC20";
    string public constant symbol = "ME20";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 private _totalSupply;

    constructor(uint256 total) {
        _totalSupply = total;
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public returns (bool) {
        //Check if sender has enaugh tokens
        require(numTokens <= balances[msg.sender]);
        //Transfer and emit event
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;

        // Emit event.
        emit Approval(msg.sender, delegate, numTokens);
        
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public returns (bool) {
        //Check if sender has enaugh tokens
        require(numTokens <= balances[owner]);
        //Check if sender is approved to send the amount
         require(numTokens <= allowed[owner][msg.sender]);
        //Transfer and emit event
        balances[msg.sender] -= numTokens;
        allowed[owner][msg.sender] -= numTokens;
        balances[buyer] += numTokens;
        emit Transfer(msg.sender, buyer, numTokens);
        return true;
    }
}