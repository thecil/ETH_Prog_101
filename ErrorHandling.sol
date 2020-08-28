pragma solidity 0.5.12; //must always be the 1st line to know which is the solidity version that will be used
//pragma experimental ABIEncoderV2; //Experimental encoder, not used on production


contract HelloWorld{
    
    //struct for person
    struct Person{
        string name;
        uint age;
        uint height;
        bool senior;

    }
    
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
        delete people[creator];
        assert(people[creator].age == 0);
    }
    
    //only to contract owner, check address from creators index
    function getCreator(uint index) public view onlyOwner returns(address){
        return creators[index];
    }
}
