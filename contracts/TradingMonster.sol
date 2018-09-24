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

}
