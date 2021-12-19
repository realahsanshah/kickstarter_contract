// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Compaign {
    struct Request{
        string description;
        uint256 value;
        address payable recipient;
        bool completed;
        uint256 approvalCount;
        mapping(address=>bool) approvals;
    }

    address public manager;
    uint256 public minimumContribution;
    uint256 public totalFunds;
    mapping(address=>bool) public approvers;
    uint256 public totalBackers;
    uint public numRequests;
    mapping(uint => Request) public requests;    

    modifier onlyManager(){
        require(msg.sender==manager,"Only Manager can do this transaction");
        _;
    }

    constructor(uint256 _minimumContribution,address sender){
        manager = sender;
        minimumContribution = _minimumContribution;
    }

    function contribute() public payable{
        require(msg.value>=minimumContribution,"Insufficient Money");
        
        totalFunds+=msg.value;
        approvers[msg.sender] = true;
        totalBackers++;
    }

    function createRequest(string memory description,uint256 value,address payable recipient) public onlyManager{
        require(value<=totalFunds,"Insufficient balance");
        Request storage r = requests[numRequests++];
        r.description = description;
        r.value = value;
        r.recipient = recipient;
        r.completed = false;
        r.approvalCount = 0;
    }

    function approveRequest(uint256 index) public {
        require(approvers[msg.sender],"Only contributer can approve requests");
        require(!requests[index].approvals[msg.sender],"You can vote only once for a request");

        requests[index].approvals[msg.sender]=true;
        requests[index].approvalCount++;
    }

    function finalizeRequest(uint256 index) public onlyManager{
        require(!requests[index].completed,"Already finalized");
        require((requests[index].approvalCount>(totalBackers/2)),"Not enough votes");
        require((requests[index].value<=totalFunds),"Not enough funds");

        requests[index].recipient.transfer(requests[index].value);
        requests[index].completed=true;
    }
}