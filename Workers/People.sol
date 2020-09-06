import "./Ownable.sol";

pragma solidity 0.5.12;

contract People is Ownable{
    
    struct Person{
        string name;
        uint age;
        uint height;
        bool senior;
    }
    
    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address creator);
    event withdrawedAll(address creator, string msg);
    
    uint public balance;
    
    mapping(address => Person) private people;
    address[] private creators;
    
    //Make sure to figure out the correct visibility level for the createPerson function (it should no longer be public)
    function createPerson(string memory name, uint age, uint height) internal{
        require(age < 150, "Age need to be below 150");
        balance += msg.value;
        
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        
        if(age < 65){
            newPerson.senior = false;
        }else{
            newPerson.senior = true;
        }
        
        insertPerson(newPerson);
        creators.push(msg.sender);
        
        //people[msg.sender] == newPerson HASH
        assert(
            keccak256(
                abi.encodePacked(
                    people[msg.sender].name,
                    people[msg.sender].age,
                    people[msg.sender].height,
                    people[msg.sender].senior)
                    ) == keccak256(
                        abi.encodePacked(
                            newPerson.name,
                            newPerson.age,
                            newPerson.height,
                            newPerson.senior)
                            )
        );
        emit personCreated(newPerson.name, newPerson.senior);
    }
    
    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
        people[creator] = newPerson;
    }
    
    function getPerson() public view returns(string memory, uint256, uint256, bool){
        address creator = msg.sender;
        return(people[creator].name,
        people[creator].age,
        people[creator].height,
        people[creator].senior);
    }
    
    function deletePerson(address creator) internal onlyOwner{
        string memory name = people[creator].name;
        bool isSenior = people[creator].senior;
        delete people[creator];
        assert(people[creator].age == 0);
        emit personDeleted(name, isSenior, msg.sender);
    }
    
    //only to contract owner, check address from creators index
    function getCreator(uint index) public view onlyOwner returns(address){
        return creators[index];
    }
        //how to use "transfer"
    function withdrawAll() public onlyOwner{
        uint toTransfer = balance;
        balance = 0;
        msg.sender.transfer(toTransfer);
        emit withdrawedAll(msg.sender, "All funds has been withdrawed by contract Creator");
    }
    
}
