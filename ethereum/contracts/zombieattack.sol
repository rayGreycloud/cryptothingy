pragma solidity ^0.4.19;

import "./zombiehelper.sol";

/**
 * @title ZombieBattle
 */
contract ZombieBattle is ZombieHelper {
  // Emits results of the attack 
  event AttackResult(uint indexed attackingZombie, uint indexed enemyZombie, bool attackSuccess);
  
  // Initialize nonce used to generate pseudo-random modulus  
  uint randNonce = 0;
  // Set probability of attack success 
  uint attackVictoryProbability = 70;
  // Initialize success flag
  bool attackSuccess;

  /**
  * @dev Function to generate pseudo-random number representing attack results.
  * @param _modulus Number used in rng process.
  * @return pseudo-random uint.
  */
  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }
  
  /**
  * @dev Function to simulate attack on another zombie and process results 
  * @param _zombieId The uint id of attacking zombie.
  * @param _targetId The uint id of zombie target.
  * @dev onlyOwnerOf restricts to owner of attacking zombie
  */
  function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
    // Save ids of attacker and target 
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];
    uint rand = randMod(100);
    if (rand <= attackVictoryProbability) {
      /* myZombie.winCount = myZombie.winCount.add(1); */
      myZombie.winCount++;
      myZombie.level = myZombie.level.add(1);
      enemyZombie.lossCount = enemyZombie.lossCount.add(1);
      attackSuccess = true;      
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } else {
      myZombie.lossCount++;
      enemyZombie.winCount++;
      attackSuccess = false;
      _triggerCooldown(myZombie);
    }
    
    AttackResult(_zombieId, _targetId, attackSuccess);
  }
}
