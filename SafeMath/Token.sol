pragma solidity 0.5.12;

import "./Ownable.sol";
import "./SafeMath.sol";

contract ERC20 is Ownable{
    
    using SafeMath for uint256;
    
    mapping (address => uint256) private _balances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor() public {
        _name = 'NameCoin';
        _symbol = 'NAM';
        _decimals = 18;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function mint(address account, uint256 amount) public onlyOwner{
        require(account != address(0), "Can't mint to zero address");
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Cant transfer to zero address");
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        
        emit Transfer(msg.sender, recipient,amount);
        return true;
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}
