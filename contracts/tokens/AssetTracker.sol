// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";


contract AssetTracker is Ownable {

    mapping(string=>address) public asset_map;

    constructor() public Ownable(){}

    function add_asset(string memory symbol, address _asset_token_addr) external {
        asset_map[symbol] = _asset_token_addr;
    }

    // views

    function get_asset(string memory symbol) external view returns(address) {
        return asset_map[symbol];
    }

    /* ========== EVENTS ========== */
}