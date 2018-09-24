module.exports = function(TradingMonster, accounts) {
  function checkMonsterCreation (name, age, dna) {
    it('createToken creates a monster', function (done) {
      TradingMonster.deployed().then(async function (instance) {
        await instance.createMonster(name, age, dna, {
          from: accounts[0]
        }).then(function (result) {
          assert.include(result.logs[0].event, 'MonsterCreated');
        });
      }).then(done).catch(done);
    });
  };
  return {
    checkMonsterCreation: checkMonsterCreation,
  };
};
