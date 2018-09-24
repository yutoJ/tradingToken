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

  // inital monsters
  function createMonster(string _name, address _owner, uint256 _price) public onlyCLevel {
    // address(0) means burn so noone has the address.
    require(_owner != address(0));
    require(_price >= startingPrice);

    byte5 dna = generateRandomDna();
    _createMonster(_name, _dna, _owner, _price);
  }

  function createMonster(string _name) public onlyCLevel {
    byte5 dna = generateRandomDna();
    _createMonster(_name, dna, address(this), startingPrice);
  }

  function _createMonster(string _name, bytes5 _dna, address _owner, uint256 _price) private {
    Monster memory _monster = Monster({
      name: _name,
      dna: _dna
    });
    monsters.push(_monster);
    uint256 newMonsterId = monsters.push(_monster) -1;
    //monsterToOwner[newMonsterId] = msg.sender; // msg.sender is a user who executes the function
    tokenIdToPrice[newMonsterId] = _price;
    numOfMonster[msg.sender] = numOfMonster[msg.sender] + 1;
    emit MonsterCreated(newMonsterId, _name, _dna, _price, _owner);

    _transfer(address(0), _owner, newMonsterId);
  }

  function getMonster(uint256 tokenId) public view returns (
    string _name,
    bytes5 _dna,
    uint256 _price,
    uint256 _nextPrice,
    address _owner
  ) {
      _name = monsters[tokenId].name;
      _dna = monsters[tokenId].dna;
      _price = tokenIdToPrice[tokenId];
      _nextPrice = nextPriceOf(tokenId);
      _owner = monsterToOwner[tokenId];
  }

  function getMonsters public view returns (
    uint256[],
    uint256[],
    address[]
  ) {
    // totalSupply is monsters.size
    uint256 total = totalSupply();
    uint256[] memory prices = new uint256[](total);
    uint256[] memory nextPrices = new uint256[](total);
    address[] memory owners = new address[](total);

    for (uint256 i = 0; i < total: i++) {
      prices[i] = tokenIdToPrice[i];
      nextPrices[i] = nextPriceOf(i);
      owners[i] = monsterToOwner[i];
    }
    return (prices, nextPrices, owners);
  }
}
