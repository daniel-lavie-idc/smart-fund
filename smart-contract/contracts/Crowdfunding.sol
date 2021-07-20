// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

import './SafeMath.sol';
import './ECDSA.sol';


contract Crowdfunding {
    using SafeMath for uint256;

    // List of existing projects
    Project[] private projects;

    // Event that will be emitted whenever a new project is started
    event ProjectStarted(
        address contractAddress,
        address projectStarter,
        uint256 deadline,
        uint256 goalAmount
    );

    function startProject(
        string memory projectId,
        uint durationInDays,
        uint amountToRaise,
        address pk1,
        address pk2,
        address pk3
    ) external {
        uint raiseUntil = block.timestamp.add(durationInDays.mul(1 days));
        Project newProject = new Project(projectId, payable(msg.sender), raiseUntil, amountToRaise, pk1, pk2, pk3);
        projects.push(newProject);
        emit ProjectStarted(
            address(newProject),
            msg.sender,
            raiseUntil,
            amountToRaise
        );
    }                                                                                                                                   

    /** @dev Function to get all projects' contract addresses.
      * @return A list of all projects' contract addreses
      */
    function returnAllProjects() external view returns(Project[] memory){
        return projects;
    }
}


contract Project {
    using SafeMath for uint256;
    
    // Data structures
    enum State {
        Fundraising,
        Expired,
        Successful,
        Withdrawn
    }

    // State variables
    string public id;
    address payable public creator;
    uint public amountGoal; // required to reach at least this much, else everyone gets refund
    uint public completeAt;
    uint256 public currentBalance;
    uint public raiseBy;
    address public pk1;
    address public pk2;
    address public pk3;
    State public state = State.Fundraising; // initialize on create
    mapping (address => uint) public contributions;

    // Event that will be emitted whenever funding will be received
    event FundingReceived(address contributor, uint amount, uint currentTotal);
    // Event that will be emitted whenever the project starter has received the funds
    event CreatorPaid(address recipient);

    // Modifier to check current state
    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    // Modifier to check if the function caller is the project creator
    modifier isCreator() {
        require(msg.sender == creator);
        _;
    }

    constructor
    (
        string memory projectId,
        address payable projectStarter,
        uint fundRaisingDeadline,
        uint goalAmount,
        address projectPK1,
        address projectPK2,
        address projectPK3
    ) {
        id = projectId;
        creator = projectStarter;
        amountGoal = goalAmount;
        raiseBy = fundRaisingDeadline;
        pk1 = projectPK1;
        pk2 = projectPK2;
        pk3 = projectPK3;
        currentBalance = 0;
    }

    /** @dev Function to fund a certain project.
      */
    function contribute() external inState(State.Fundraising) payable {
        require(msg.sender != creator);
        contributions[msg.sender] = contributions[msg.sender].add(msg.value);
        currentBalance = currentBalance.add(msg.value);
        emit FundingReceived(msg.sender, msg.value, currentBalance);
        checkIfFundingCompleteOrExpired();
    }

    /** @dev Function to change the project state depending on conditions.
      */
    function checkIfFundingCompleteOrExpired() public {
        if (fundingCompleted()) {
            state = State.Successful;
        } else if (block.timestamp > raiseBy)  {
            state = State.Expired;
        }
        completeAt = block.timestamp;
    }
    
    function fundingCompleted() internal view returns (bool) {
        return currentBalance >= amountGoal;
    }
    
     /** @dev Withdraw funds. signature must be a valid signature on the project id by on of the pk's
      */
    function withdraw(bytes memory signature) public inState(State.Successful) returns (bool) {
        // require(msg.sender == creator, "withdraw is only available for the creator of the project");
        require(fundingCompleted(), "Funding is not complete yet");
        require(isSignedProperlyForWithdraw(signature), "The transaction has signatures issues");
        uint256 totalRaised = currentBalance;
        currentBalance = 0;

        if (creator.send(totalRaised)) {
            state = State.Withdrawn;
            emit CreatorPaid(creator);
            return true;
        } else {
            currentBalance = totalRaised;
            state = State.Successful;
        }

        return false;
    }
    
    function isSignedProperlyForWithdraw(bytes memory signature) internal view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(id));
        address addressThatSigned = ECDSA.recover(hash, signature);
        address transactionSignature = msg.sender;

        // require(isAddressInOneOfThePks(addressThatSigned), "internal signature is incorrect");
        // require(isAddressInOneOfThePks(msg.sender), "external signature is incorrect");
        require(isAddressesInTwoOfThePks(addressThatSigned, transactionSignature), "One of the 2 given signatures is incorrect");
        return true;
    }
    
    function isAddressesInTwoOfThePks(address a, address b) internal view returns (bool) {
        if (a == pk1) {
            return (b == pk2 || b == pk3);
        } else if (a == pk2) {
            return (b == pk1 || b == pk3);
        } else if (a == pk3) {
            return (b == pk1 || b == pk2);
        }
        return false;
    }

    /** @dev Function to retrieve donated amount when a project expires.
      */
    function getRefund() public inState(State.Expired) returns (bool) {
        require(contributions[msg.sender] > 0);

        uint amountToRefund = contributions[msg.sender];
        contributions[msg.sender] = 0;

        if (!payable(msg.sender).send(amountToRefund)) {
            contributions[msg.sender] = amountToRefund;
            return false;
        } else {
            currentBalance = currentBalance.sub(amountToRefund);
        }

        return true;
    }

    function getDetails() public view returns 
    (
        string memory projectId,
        address payable projectStarter,
        uint256 deadline,
        State currentState,
        uint256 currentAmount,
        uint256 goalAmount
    ) {
        projectId = id;
        projectStarter = creator;
        deadline = raiseBy;
        currentState = state;
        currentAmount = currentBalance;
        goalAmount = amountGoal;
    }
}