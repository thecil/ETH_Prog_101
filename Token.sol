pragma solidity 0.5.12;

import "./Ownable.sol";

contract ERC20 is Ownable{

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
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Cant transfer to zero address");
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        
        emit Transfer(msg.sender, recipient,amount);
        return true;
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}
