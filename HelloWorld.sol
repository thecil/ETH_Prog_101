pragma solidity 0.5.12; //must always be the 1st line to know which is the solidity version that will be used
pragma experimental ABIEncoderV2; //Experimental encoder, not used on production

contract HelloWorld{

    //struct variable
    struct Person{
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
        //add new data for the array Person
   
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        //
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
