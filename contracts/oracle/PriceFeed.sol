// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";


contract PriceFeed is Ownable{
    
    mapping(address => mapping(address => uint)) public asset_rates;

    constructor() public Ownable() {}

    function setRate(address from, address to, uint rate) external onlyOwner() {
        // Require amount greater than 0
        require(rate > 0, "amount cannot be 0");
        require(from != address(0), "from address is empty" );
        require(to != address(0), "to address is empty" ); 
        asset_rates[from][to] = rate;   
    }
    function getRate(address from,address to) external view returns(uint) {
        return asset_rates[from][to];
    }
}
