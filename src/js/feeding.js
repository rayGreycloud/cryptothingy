function feedOnKitty(zombieId, kittyId) {
  $("#txStatus").text("Eating a kitty. This may take a while...");
  
  return CryptoZombies.methods.feedOnKitty(zombieId, kittyId)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("Ate a kitty and spawned a new Zombie!");
    getZombiesByOwner(userAccount).then(displayZombies);
  })
  .on("error", function(error) {
    $("#txStatus").text(error);
  });
}
