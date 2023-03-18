//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Escrow {

  IERC20 public _token;
  uint numberOfDeposit;
  mapping(bytes32 => uint256) escrowBalance;

  constructor(address ERC20Address) {
    numberOfDeposit = 0;
    _token = IERC20(ERC20Address);
  }

  function getHash(uint amount) public view returns(bytes32 result){
    return keccak256(abi.encodePacked(msg.sender, numberOfDeposit, amount));
  }

  function deposit(bytes32 trx_hash, uint amount) external {
  
    require(amount != 0, "amount Cannot be 0");
    require(escrowBalance[trx_hash] == 0, "sorry, hash in use.");
    require(trx_hash[0] != 0, "The Transaction hash cannot be empty!");
    require(_token.transferFrom(msg.sender, address(this), amount), "unsuccessful escrow transfer");
    
    escrowBalance[trx_hash] = amount;
    numberOfDeposit++;
  }   

    function withdraw(bytes32 trx_hash) external {
  
    require(trx_hash[0] != 0, "Transaction hash is empty!");
    require(escrowBalance[trx_hash] != 0, "transaction hash doesn't exist.");
    require(_token.transfer(msg.sender, escrowBalance[trx_hash]), "retrieval failed!");

    escrowBalance[trx_hash] = 0;
  }
}