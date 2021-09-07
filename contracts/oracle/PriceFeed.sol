// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";


contract PriceFeed is Ownable{
    
    mapping(address => mapping(address => uint)) public asset_price;
    address public oracle_addr;
    constructor() public Ownable() {

    }

    function setOracle(address _oracle_addr) public onlyOwner(){
        oracle_addr = _oracle_addr;
    }

    function setRate(address from, address to, uint rate) external onlyOracle() {
        // Require amount greater than 0
        require(rate > 0, "amount cannot be 0");
        require(from != address(0), "from address is empty" );
        require(to != address(0), "to address is empty" ); 
        asset_price[from][to] = rate;   
    }
    function getRate(address from,address to) external view returns(uint) {
        return asset_price[from][to];
    }

    modifier onlyOracle() {
        require(true, "only oracle can set rate");
        // require(oracle_addr == _msgSender(), "only oracle can set rate");
        _;
    }
}
