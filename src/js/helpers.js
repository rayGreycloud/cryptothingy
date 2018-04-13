function levelUp(zombieId) {
  $("#txStatus").text("Leveling up your zombie...");
  
  return CryptoZombies.methods.levelUp(zombieId)
  .send({ from: userAccount, value: web3.utils.toWei("0.001", "ether") })
  .on("receipt", function(receipt) {
    $("#txStatus").text("Power overwhelming! Zombie successfully leveled up");
  })
  .on("error", function(error) {
    $("#txStatus").text(error);
  });
}

function changeName(zombieId, newName) {
  $("#txStatus").text("Changing your zombie's name. This may take a while...");
  
  return CryptoZombies.methods.changeName(zombieId, newName)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("Your zombie's name was successfully changed.");
    getZombiesByOwner(userAccount).then(displayZombies);
  })
  .on("error", function(error) {
    $("#txStatus").text(error);
  });  
}

function changeDna(zombieId, newDna) {
  $("#txStatus").text("Changing your zombie's DNA. This may take a while...");
  
  return CryptoZombies.methods.changeDna(zombieId, newDna)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("Your zombie's DNA was successfully changed.");
    getZombiesByOwner(userAccount).then(displayZombies);
  })
  .on("error", function(error) {
    $("#txStatus").text(error);
  });  
}

function getZombiesByOwner(owner) {
  return cryptoZombies.methods.getZombiesByOwner(owner).call();
}
