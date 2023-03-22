// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "../node_modules/hardhat/console.sol";

contract Lock4 {
    mapping(address => uint) public owners;
    uint256 public countOwners;
    uint8 constant allowWithdraw = 1;
    uint8 constant noWithdraw = 2;

    event Withdrawal(uint256 amount, uint256 when);
    event WithdrawalAttempt(uint amount, uint when, address adress);

    constructor() payable {
        //First owner (creator) 1 for withdraw right
        owners[msg.sender] = 1;
        countOwners = 1;
    }

    function addOwner(address newOwner) public returns (string memory) {
        newOwner = payable(newOwner);
        //not initiated
        if (owners[newOwner] == 0) {
            owners[newOwner] = allowWithdraw;
            countOwners += 1;
            return "Owner added successfully";
        } else {
            return "Owner already added";
        }
    }

    function withdraw() public {
        emit WithdrawalAttempt(address(this).balance, block.timestamp, msg.sender);

        require(owners[msg.sender] > 0, "Owner not registered");
        require(owners[msg.sender] == allowWithdraw, "You can only withdraw once");

        //Return only a fraction of the value locked
        uint256 fraction = address(this).balance / countOwners;
        emit Withdrawal(fraction, block.timestamp);
        payable(msg.sender).transfer(fraction);

        //Update info
        countOwners -= 1;
        owners[msg.sender] = noWithdraw;
    }
}
