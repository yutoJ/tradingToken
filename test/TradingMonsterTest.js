var TradingMonster = artifacts.require('TradingMonster');

contract('TradingMonster', function (accounts) {
  var helpfulFunctions = require('./utils/TradingMonsterUtils')(TradingMonster, accounts);
  var hfn = Object.keys(helpfulFunctions);
  for (var i = 0; i < hfn.length; i++) {
    global[hfn[i]] = helpfulFunctions[hfn[i]];
  }
  for (x = 0; x < 10; x++) {
    checkMonsterCreation('Monster-' + x, x, '0x0f0f0f0f0f');
  }
});
