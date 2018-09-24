pragma solidity ^0.4.24;

import './AccessControl.sol';
import './ERC721.sol';
import './SafeMath.sol';

contract DetailedERC721 is ERC721 {
    function name() public view returns (string _name);
    function symbol() public view returns (string _symbol);
}

contract TradingMonster is AccessControl, DetailedERC721 {
  using SafeMath for uint256;

  struct Monster {
    string name;
    bytes5 dna;
  }

  Monster[] private monsters;

  uint256 private startingPrice = 0.01 ether;
  bool private erc721Enabled = false;

  event MonsterCreated(uint256 id, string name, bytes5 dna, uint256 price, address owner);
  event MonsterSold(uint256 id, string name, bytes5 dna, uint256 sellingPrice, uint256 newPrice, address indexed oldAddress, address indexed newAddress);

  mapping (uint256 => address) private monsterToOwner;
  mapping (uint256 => uint256) private tokenIdToPrice;
  mapping (address => uint256) private numOfMonster;
  mapping (uint256 => address) private tokenIdToApproved;

  modifier onlyERC721() {
    require(erc721Enabled);
    _;
  }

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
