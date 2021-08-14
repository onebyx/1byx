// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;


import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/token/ERC20/IERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";
import "./../oracle/IPriceFeed.sol";
import "./../tokens/IAssetTracker.sol";
import "./../tokens/ISynth.sol";


contract Staker is Ownable{
    IERC20 public ONX;
    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;
    uint256 public totalstaked;
    ISynth public sUSD;
    IPriceFeed public pf;
    IAssetTracker public at;

    constructor(IERC20 _ONX,IPriceFeed _pf, IAssetTracker _at) public Ownable(){
        ONX = _ONX;
        pf= _pf;
        at = _at;
    }

    function stakeTokens(uint _amount) public {
        // Require amount greater than 0
        require(_amount > 0, "amount cannot be 0");

        // Trasnfer ONX tokens to this contract for staking
        ONX.transferFrom(msg.sender, address(this), _amount);

        // Update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        // Add user to stakers array *only* if they haven't staked already
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // Update staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
        totalstaked += _amount;
        // mint susd
        // todo add address check
        sUSD = ISynth(at.get_asset("sUSD"));
        // todo fetch price feed
        // mint it
        sUSD.issue(msg.sender,10);

    }

    // Unstaking Tokens 
    function unstakeTokens() public {
        // todo burn synth token


        // Fetch staking balance
        uint balance = stakingBalance[msg.sender];

        // Require amount greater than 0
        require(balance > 0, "staking balance cannot be 0");

        // Transfer ONX tokens Back to the user
        ONX.transfer(msg.sender, balance);

        // Reset staking balance
        stakingBalance[msg.sender] = 0;

        // Update staking status
        isStaking[msg.sender] = false;
        totalstaked -= balance;
    }

}
