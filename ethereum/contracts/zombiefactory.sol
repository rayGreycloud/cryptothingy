pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

/**
 * @title ZombieFactory
 */
contract ZombieFactory is Ownable {
  
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;
    
    // Emits details when new Zombie created
    event NewZombie(uint zombieId, string name, uint dna);
    
    // Specifies number of digits in 'dna' code
    uint dnaDigits = 16;
    // Generates modulus for use in pseudo-random number generation
    uint dnaModulus = 10 ** dnaDigits;
    // Period of time during which Zombie can't attack
    uint cooldownTime = 1 days;

    // Defines zombie properties
    struct Zombie {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
      uint16 winCount;
      uint16 lossCount;
    }
    /**
    * @dev Public state variable - array of Zombie structs
    * @param Getter takes uint zombieId.
    * @return Getter returns Zombie struct.
    */    
    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    /**
    * @dev internal function to create new zombie 
    * @param _name The name for the new zombie.
    * @param _dna The 'dna' code for new zombie.
    */
    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);
        NewZombie(id, _name, _dna);
    }
    
    /**
    * @dev internal function to generate random 'dna' uint 
    * @param _str The string to hash and uint.
    * @return pseudo-random uint 
    */
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }
    
    /**
    * @dev create random zombie for first zombie 
    * @param _name The string representing new name.
    */
    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }
}
