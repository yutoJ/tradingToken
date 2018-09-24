pragma solidity ^0.4.24;

contract TradingMonster {

  // class
  struct Monster {
    string name;
    uint age;
    bytes5 dna;
  }

  Monster[] monsters;

  mapping (uint256 => address) private monsterToOwner;
  mapping (address => uint256) private numOfMonster;

  event MonsterCreated(uint256 _id, string _name, uint _age, bytes5 _dna);

  function createMonster(string _name, uint _age, bytes5 _dna) public {
    Monster memory _monster = Monster({
      name: _name,
      age: _age,
      dna: _dna
    });
    monsters.push(_monster);
    uint256 newMonsterId = monsters.push(_monster) -1;
    monsterToOwner[newMonsterId] = msg.sender; // msg.sender is a user who executes the function
    numOfMonster[msg.sender] = numOfMonster[msg.sender] + 1;
    emit MonsterCreated(newMonsterId, _name, _age, _dna);
  }
}
