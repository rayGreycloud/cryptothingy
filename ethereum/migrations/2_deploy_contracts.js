let ZombieOwnership = artifacts.require("zombieownership");

module.exports = function(deployer) {
  deployer.deploy(ZombieOwnership);
};
