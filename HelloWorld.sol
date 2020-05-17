pragma solidity 0.5.12; //must always be the 1st line to know which is the solidity version that will be used
pragma experimental ABIEncoderV2;

contract HelloWorld{
    
    /*
    //get the string from "message" variable, 'view' means that the function
    //will only show the variable value
    function getMessage() public view returns(string memory){
        return message;
    }
    
    //set a new string from "message" variable
    function setMessage(string memory newMessage) public{
        message = newMessage;
    }
    
    //get the uint from "numbers" variable, 'view' means that the function
    //will only show the variable value
    function getNumber(uint index) public view returns(uint){
        return numbers[index];
    }
    
    //set a new number on the index specified
    function setNumber(uint newNumber, uint index) public{
        numbers[index] = newNumber;
    }
    
    function addNumber(uint newNumber) public{
        numbers.push(newNumber);
    }
    
    function createPerson(string memory name, uint age, uint height) public{
        people.push(Person(people.length, name, age, height));
    }
    
    //type of variables
    string public message = "Hello World";
    uint public number = 123;
    bool public isHappy = true;
    address public contractCreator = 0x12b6F5E797235715a122481E2bf440Fb1895079d;
    //end variables
    
    //Array variable
    uint[] public numbers = [1, 20, 45];
    string[] public messages = ["Hello", "World", "Again"];
    uint[3] public numbersfixed = [1, 2, 3];
    //end Array variable
    
    */
    
    //struct variable
    struct Person{
        uint id;
        string name;
        uint age;
        uint height;
        //address walletAddress;
    }
    //end struct
    
   
    
    //Instance for struct
    Person[] public people;
    //end Instance
    
    //mapping to track balance from address of an user
     mapping(address => Person) private peopleMap;
    //end mapping
    

    
    function createPerson2(string memory name, uint age, uint height) public{
        //give the address of the sender on this function
        address creator = msg.sender;
        //This create a Person
        Person memory newPerson;
        //newPerson.id = people.length;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        peopleMap[creator] = newPerson;
        
        //people.push(newPerson);
    }
    
    function getPerson() public view returns(string memory name, uint age, uint height){
        //set to only get the mapping from the account creator
        address creator = msg.sender;
        //return only the data from the owner of the account
        return(peopleMap[creator].name, peopleMap[creator].age, peopleMap[creator].height);
    }
}
