pragma solidity ^0.4.19;

import "./zombieattack.sol";
import "./erc721.sol";
import "./safemath.sol";

/**
 * @title ZombieOwnership
 */
contract ZombieOwnership is ZombieBattle, ERC721 {
  
  using SafeMath for uint256; 
  
  // Takes uint zombieId and returns approved owner address
  mapping (uint => address) zombieApprovals;
  
  /**
  * @dev Function to get number of zombies owned by owner.
  * @param _owner The address of owner.
  * @return  _balance The zombie count of that ouwner
  */
  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerZombieCount[_owner];
  }
  
  /**
  * @dev Function to get owner of zombie.
  * @param _tokenId The uint256 id of zombie.
  * @return  _owner The address of owner
  */  
  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return zombieToOwner[_tokenId];
  }
  
  /**
  * @dev Internal function to transfer zombie 
  * @param _from The address of transferor.
  * @param _to The address of recipient.
  * @param _tokenId The id of the zombie
  */  
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
    ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
    zombieToOwner[_tokenId] = _to;
    
    Transfer(_from, _to, _tokenId);
  }
  
  /**
  * @dev Function to transfer zombie 
  * @param _to The address of recipient.
  * @param _tokenId The uint256 id of the zombie
  */    
  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }
  
  /**
  * @dev Function for owner to approve transfer of zombie 
  * @param _to The address of recipient.
  * @param _tokenId The id of the zombie
  */    
  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    zombieApprovals[_tokenId] = _to;
    
    Approval(msg.sender, _to, _tokenId);
  }
  
  /**
  * @dev Function for recipient to take ownership of zombie 
  * @param _tokenId The id of the zombie
  * @dev Requires sender to be approved for that zombie
  */    
  function takeOwnership(uint256 _tokenId) public {
    require(zombieApprovals[_tokenId] == msg.sender);
    
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}
