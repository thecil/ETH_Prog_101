pragma solidity 0.5.12;

//definition of HelloWorld contract, INTERFACE
contract HelloWorld{
    function createPerson(string memory name, uint age, uint height) public payable;
    function getPerson() public view returns(string memory, uint256, uint256, bool);
}

contract externalContract{
    
    //define an instance to interact with a contract
    HelloWorld instance = HelloWorld(0xE958D39c97216b45b46dC45c846931F12E99D78F);
    
    
    function externalCreatePerson(string memory name, uint age, uint height) public payable{
        //call createPerson in HelloWorld contract
        instance.createPerson.value(msg.value)(name, age, height);
        //forward any ether to HelloWorld contract
    }
    
    function externalGetPerson()public view returns(string memory, uint256, uint256, bool){
        return instance.getPerson();
    }
}
