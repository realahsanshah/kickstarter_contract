// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
import "./Compaign.sol";

contract CompaignFactory{
    Compaign[] public deployedContracts;

    function createCompaign(uint256 _minimumContribution) public{
        Compaign compaign = new Compaign(_minimumContribution,msg.sender);
        deployedContracts.push(compaign);
    }

    function getDeployedCompaigns() public view returns(Compaign[] memory){
        return deployedContracts;
    }
}   