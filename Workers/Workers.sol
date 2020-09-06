import "./People.sol";

pragma solidity 0.5.12;

//Should inherit from the People Contract
contract Workers is People{
    
    struct Worker{
        address boss;
        address payoutAddress;
        uint salary;
    }
    
    modifier costs(uint cost){
        require(msg.value >= cost, "Incorrect Price");
        _;
    }
    
    //adding another mapping called salary which maps an address to an integer.
    mapping(address => Worker) private payout;
    
    event workerCreated(address boss, address payoutAddress, uint salary);
    event workerDeleted(address boss, string msg);

    //Have a createWorker function which is a wrapper function for the createPerson function.
    function createWorker(string memory name, uint age, uint height, address payoutAddress, uint workerSalary) public payable costs(100 wei){
        // the persons age should not be allowed to be over 75
        require(age <= 75, "Worker above 75, not allowed.");
        //A worker is not allowed to be his/her own boss. 
        require(msg.sender != payoutAddress, "You can not pay to yourself.");
        require(workerSalary != 0, "Worker must have a salary");
        
        Worker memory newWorker;
        newWorker.boss = msg.sender;
        newWorker.payoutAddress = payoutAddress;
        //should also set the salary for the Worker in the new mapping
        newWorker.salary = workerSalary;
        //which is a wrapper function for the createPerson function
        createPerson(name, age, height);
        payout[msg.sender] = newWorker;
        
        emit workerCreated(msg.sender, payoutAddress, workerSalary);
    }
    
    function getWorker() public view returns(address, address, uint){
        address creator = msg.sender;
        return(payout[creator].boss, payout[creator].payoutAddress, payout[creator].salary);
    }
    
    //Implement a fire function, which removes the worker from the contract
    function fireWorker(address boss) public{
        require(msg.sender == payout[msg.sender].boss, "Only owner can delete his worker");
        deletePerson(msg.sender);
        delete payout[boss];
        emit workerDeleted(boss, "Worker has been deleted");
    }
    
}
