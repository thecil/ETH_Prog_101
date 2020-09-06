import "./Ownable.sol";

pragma solidity 0.5.12;

contract Destroyable is Ownable{
    event contractDestroy(address creator, string msg);
    
    function destroyContract() public onlyOwner{
        address payable receiver = msg.sender;
        selfdestruct(receiver);
        emit contractDestroy(msg.sender, "Contract has been destroyed by the owner");
    }
}
