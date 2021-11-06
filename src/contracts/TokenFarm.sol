pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm{
    string public name = "Dapp Token Farm";
    address public owner;
    DappToken public dappToken; 
    DaiToken public daiToken;

    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public isStaking;
    mapping(address => bool) public hasStaked;

    address[] public stakers;
    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // 1. Stakes Tokens (Deposit)
    function stakeTokens(uint _amount) public {
        // Require amount greater than 0
        require(_amount > 0, 'ammount cannot be 0 or less');

        // Transfer Mock Dai tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);
 
        //Update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] +_amount;

        // Add user to stakers array *only* if they haven't stake already
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        //Update Staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;


    }


    //  Unstaking Tokens (Withdraw)

    //  Issuing Tokens (Earn interest)
    function issueToken() public {
        require(msg.sender == owner, "caller must be the owner");

        //Issue tokens to all stakers
        for (uint i=0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if (balance > 0){
                dappToken.transfer(recipient,balance);
            }
        }
    }
}