pragma solidity ^0.4.19;

import "./zombiefeeding.sol";
import "./safemath.sol";

/**
 * @title ZombieHelper
 */
contract ZombieHelper is ZombieFeeding {

  using SafeMath32 for uint256;
  using SafeMath32 for uint32;
  using SafeMath16 for uint16;

  // Set level up fee
  uint levelUpFee = 0.001 ether;
  
  /**
  * @dev Modifier restriction to zombie of specified level.
  * @param _level Level required for action.
  * @param  _zombieId Id of Zombie involved.
  */  
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  /**
  * @dev Function allowing owner to withdraw contract balance.
  */
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }
  
  /**
  * @dev Function to level up zombie 
  * @param _zombieId Uint Id of Zombie to level up.
  */
  function levelUp(uint _zombieId) external payable {
    require(msg.value == levelUpFee);
    uint32 _level = zombies[_zombieId].level.add(1);
    zombies[_zombieId].level = _level;
  }  
  
  /**
  * @dev Function for contract owner to set level up fee.
  * @param _fee The amount of the fee.
  */
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }
  
  /**
  * @dev Function to change Zombie's name.
  * @dev Modifer requires Zombie level >= 2.
  * @param _zombieId Id of Zombie.
  * @param _newName String name for Zombie.
  */
  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) onlyOwnerOf(_zombieId) {
    zombies[_zombieId].name = _newName;
  }
  
  /**
  * @dev Function to change zombie's dna.
  * @dev Modifier requires Zombie level >= 20.
  * @param _zombieId Id of Zombie.
  * @param _newDna Uint 'dna' for Zombie.
  */
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) onlyOwnerOf(_zombieId) {
    zombies[_zombieId].dna = _newDna;
  }
  
  /**
  * @dev Function to get Zombies of specified owner.
  * @param _owner The address of specified owner.
  * @return result Array of uints representing owner's zombies.
  */
  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    // Initialize array of size equal to number of owner's zombies
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    // Initialize counter for index of result array
    uint counter = 0;
    // Iterate thru zombies 
    for (uint i = 0; i < zombies.length; i++) {
      // Check if belongs to owner
      if (zombieToOwner[i] == _owner) {
        // Add to result array 
        result[counter] = i;
        // Increment counter 
        counter++;
      }
    }
    return result;
  }

}
