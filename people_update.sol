pragma solidity 0.5.12; //must always be the 1st line to know which is the solidity version that will be used

/*
In today's assignment, I want you to add some extra functionality to our Helloworld contract. 
I want you to use the original contract that I use in the videos, not the modified one you created in the assignment yesterday.

1. Implement a function or functions so that the people in the mapping can update their information. 
Make sure to use the correct data location so that the update is saved. 
This function should use assert to verify that the changes have taken place.

2. Create an event called PersonUpdated that is emitted when a persons information is updated. 
The event should contain both the old and the updated information of the person. 
*/

contract HelloWorld{
    
    //struct for person
    struct Person{
        string name;
        uint age;
        uint height;
        bool senior;

    }
    
    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);
    //2. Create an event called PersonUpdated that is emitted when a persons information is updated. 
    //The event should contain both the old and the updated information of the person. 
    event personUpdated(string prevName, uint prevAge, uint prevHeight, bool prevSenior, string newName, uint newAge, uint newHeight, bool newSenior, address deletedBy);
    
    address public owner;
    
    modifier onlyOwner(){
        require(msg.sender == owner, "Contract Owner Only");
        _;
    }
    //constructor, runs when the contract is created first time, instanciate at the begins
    constructor() public{
        owner = msg.sender;
    }

    mapping(address => Person) private people;
    
    //only accesible by contract owner
    address[] private creators; //list all addresses used to create people in the mapping
   
    
    function createPerson(string memory name, uint age, uint height) public{
        require(age <= 150, "Age should be below 150");
        //This creates a person, storage
        Person memory newPerson;

        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        if(age > 65){
            newPerson.senior = true;
        }else{
            newPerson.senior = false;
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
    
    function deletePerson(address creator) public onlyOwner{
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
    
    //1. Implement a function or functions so that the people in the mapping can update their information.
    function udpdatePerson(string memory newName, uint newAge, uint newHeight) public onlyOwner{
        address creator = msg.sender;
        //save locally previous person data 
        string memory prevName = people[creator].name;
        uint prevAge = people[creator].age;
        uint prevHeight = people[creator].height;
        bool prevSenior = people[creator].senior;
       
        //Make sure to use the correct data location so that the update is saved. 
        people[creator].name = newName;
        people[creator].age = newAge;
        people[creator].height = newHeight;       
        if(newAge > 65){
            people[creator].senior = true;
        }else{
            people[creator].senior = false;
        }
        
        bool newSenior = people[creator].senior;
        //This function should use assert to verify that the changes have taken place.
        assert(
            keccak256(
                abi.encodePacked(
                    people[msg.sender].name,
                    people[msg.sender].age,
                    people[msg.sender].height,
                    people[msg.sender].senior)
                    ) == keccak256(
                        abi.encodePacked(
                            people[creator].name,
                            people[creator].age,
                            people[creator].height,
                            people[creator].senior)
                            )
        );
        emit personUpdated(prevName, prevHeight, prevAge, prevSenior, newName,  newAge, newHeight, newSenior, msg.sender);
    }
}
 
