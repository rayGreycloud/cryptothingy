pragma solidity ^0.4.19;

import "./zombiehelper.sol";

contract ZombieBattle is ZombieHelper {
  
  event AttackResult(uint indexed attackingZombie, uint indexed enemyZombie, bool attackSuccess);
  
  uint randNonce = 0;
  uint attackVictoryProbability = 70;
  bool attackSuccess;

  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
  }

  function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
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
