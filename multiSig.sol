//"SPDX-License-Identifier: MIT"
pragma solidity 0.7.5;
pragma abicoder v2;
contract Ownable{
  address payable private owner;

  modifier onlyOwner{
    require(msg.sender == owner,"Only contract owner allowed");
    _;
  }
  constructor(){
    owner = msg.sender;
  }
}

contract multiSig is Ownable{
    address[] private owners;
    uint limit;

    struct Transfer{
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }
    event depositDone(address indexed _from, uint _amount);
    event transferDone(address indexed _from, address indexed _to, uint _amount);
    event transferRequested(address indexed _from, uint _amount);
    event transferApproved(uint _id, address indexed _from, uint _amount);

    Transfer[] internal transferRequests;

    mapping(address => mapping(uint => bool)) approvals;

    //Should only allow people in the owners list to continue the execution.
    modifier onlyOwners(){
      bool isOwner = false;
      for(uint _index = 0; _index < owners.length; _index++){
        if(owners[_index] == msg.sender){
          isOwner = true;
        }
      }
      require(isOwner == true, "Only multisig owners allow");
      _;
    }

    //Should initialize the owners list and the limit
    constructor(address _owner1, address _owner2, address _owner3, uint _limit) {
      require(_owner1 != _owner2 && _owner1 != _owner3 && _owner2 != _owner3, "Signatures should be different");
      owners = [_owner1, _owner2, _owner3];
      limit = _limit;
    }

    //Empty function
    function deposit() public payable {
      require(msg.value > 0, "Value should be above zero");
      emit depositDone(msg.sender, msg.value);
    }

    //Create an instance of the Transfer struct and add it to the transferRequests array
    function createTransfer(uint _amount, address payable _receiver) public onlyOwners {
      require(address(this).balance > _amount, "Insuficient Contract Funds");
      transferRequests.push(Transfer(_amount, _receiver, 0, false, transferRequests.length));
      emit transferRequested(_receiver, _amount);
    }

    //Set your approval for one of the transfer requests.
    function approve(uint _id) public onlyOwners {
      //An owner should not be able to vote on a tranfer request that has already been sent.
      require(transferRequests[_id].hasBeenSent == false, "Transfer already approved");
      //An owner should not be able to vote twice.
      require(approvals[msg.sender][_id] == false, "Transfer already signed by this account");
      //Need to update the mapping to record the approval for the msg.sender.
      approvals[msg.sender][_id] = true;
      transferRequests[_id].approvals++ ;
      //When the amount of approvals for a transfer has reached the limit, this function should send the transfer to the recipient.
      if(transferRequests[_id].approvals == limit){
        transferRequests[_id].receiver.transfer(transferRequests[_id].amount);
        //Need to update the Transfer object.
        transferRequests[_id].hasBeenSent = true;
        emit transferApproved(_id, transferRequests[_id].receiver, transferRequests[_id].amount);
      }
    }

    //Should return all transfer requests
    function getTransferRequests() public view returns (Transfer[] memory){
        return transferRequests;
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
}
