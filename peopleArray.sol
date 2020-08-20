pragma solidity 0.5.12; //must always be the 1st line to know which is the solidity version that will be used
pragma experimental ABIEncoderV2; //Experimental encoder, not used on production

/*
Instead of having a mapping where we store people, create a new array where we can store the people. 

When someone creates a new person, add the Person object to the people array instead of the mapping.

Create a public get function where we can input an index and retrieve the Person object with that index in the array.

Modify the Person struct and  add an address property Creator. Make sure to edit the createPerson function so that it sets this property to the msg.sender.

Bonus Assignments:
- Create a new mapping (address to uint) which stores the number of people created by a specific address.
- Modify the createPerson function to set/update this mapping for every new person created.

Bonus Assignment #2 [Difficult]:
- Create a function that returns an array of all the ID's that the msg.sender has created.
*/

contract HelloWorld{
    
    //struct for person
    struct Person{
        uint id;
        string name;
        uint age;
        uint height;
        address owner;
    }
    
    //Instance for struct as an array
    Person[] private people;
    
    /*
    Bonus Assignments:
    - Create a new mapping (address to uint) which stores the number of people created by a specific address.
    */
    mapping(address => uint256[]) total_people; //map address -> array[]
   
    
    function createPerson(string memory name, uint age, uint height) public{
        //insert Data
        people.push(Person(people.length,
                            name,
                            age,
                            height,
                            msg.sender
        ));
        /*
        Bonus Assignments:
        - Modify the createPerson function to set/update this mapping for every new person created.
        */
        total_people[msg.sender].push(people.length - 1); //-1 need it to save last index position
    }
    
    
    /*
    Bonus Assignment #2 [Difficult]:
    - Create a function that returns an array of all the ID's that the msg.sender has created.
    */
    function getPerson() public view returns(uint256[] memory){
        //set to only get the mapping from the account owner
        return (total_people[msg.sender]);
    }
}
