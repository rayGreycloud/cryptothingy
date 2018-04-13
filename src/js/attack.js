
function attack(zombieId, targetId) {
  $("#txStatus").text("Attacking a zombie. This may take a while...");
  
  return CryptoZombies.methods.attack(zombieId, targetId)
  .send({ from: userAccount })
  .on("receipt", function(receipt) {
    $("#txStatus").text("The attack on the enemy zombie has finished. You can see the results on your zombie's listing");
    getZombiesByOwner(userAccount).then(displayZombies);
  })
  .on("error", function(error) {
    $("#txStatus").text(error);
  });  
}

