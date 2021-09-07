// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";


contract AssetTracker is Ownable {
    // symbol:addr
    mapping(string=>address) public asset_map;
    // symbol: base symbol eg sINR : sUSD
    mapping(string=>string) public asset_base_symbol;
    // sINR:inr
    mapping(string=>string) public asset_oracle_symbol;
    // [sUSD,sINR]
    string[] public assets;

    constructor() public Ownable(){}

    function add_asset(string memory symbol, address _asset_token_addr, string memory _baseSymbol, string memory _oracleSymbol) external {
        if(asset_map[symbol] == address(0)){
            assets.push(symbol);
        }
        asset_map[symbol] = _asset_token_addr;
        asset_base_symbol[symbol] = _baseSymbol;
        asset_oracle_symbol[symbol] = _oracleSymbol;
    }

    // views

    function get_asset(string memory symbol) external view returns(address) {
        return asset_map[symbol];
    }

    function get_asset_base_symbol(string memory symbol) external view returns(string memory) {
        return asset_base_symbol[symbol];
    }

    function get_asset_oracle_symbol(string memory symbol) external view returns(string memory) {
        return asset_oracle_symbol[symbol];
    }

}