
require('./factory.js');
require('./feeding.js');
require('./helpers.js');
require('./attack.js');
require('./ownership.js');

let cryptoZombies;
let userAccount;

function startApp() {
  let cryptoZombiesAddress = "YOUR_CONTRACT_ADDRESS";
  cryptoZombies = new web3js.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);

  let accountInterval = setInterval(function() {
    if (web3.eth.accounts[0] !== userAccount) {
      userAccount = web3.eth.accounts[0];

      getZombiesByOwner(userAccount)
      .then(displayZombies);
    }
  }, 100);
  
  let web3Infura = new Web3(new Web3.providers.WebsocketProvider("wss://mainnet.infura.io/ws"));
  let czEvents = new web3Infura.eth.Contract(cryptoZombiesABI, cryptoZombiesAddress);
  
  czEvents.events.Transfer({ filter: { _to: userAccount } })
  .on("data", function(event) {
  let data = event.returnValues;
  
  getZombiesByOwner(userAccount).then(displayZombies);
}).on("error", console.error);
}

function displayZombies(ids) {
  $("#zombies").empty();
  
  for (id of ids) {
    getZombieDetails(id)
    .then(function(zombie) {
      $("#zombies").append(
        `<div class="zombie">
          <ul>
            <li>Name: ${zombie.name}</li>
            <li>DNA: ${zombie.dna}</li>
            <li>Level: ${zombie.level}</li>
            <li>Wins: ${zombie.winCount}</li>
            <li>Losses: ${zombie.lossCount}</li>
            <li>Ready Time: ${zombie.readyTime}</li>
          </ul>
        </div>`
      );
    });
  }
}

window.addEventListener('load', function() {
  // Checking for web3 in browser
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    web3js = new Web3(web3.currentProvider);
  } else {
    // todo - show message prompting user to install Metamask
  }

  // Start app 
  startApp();
});