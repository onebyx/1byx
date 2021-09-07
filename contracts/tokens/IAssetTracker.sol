// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface IAssetTracker {
    function add_asset(string memory, address, string memory, string memory) external ;
    function get_asset(string memory symbol) external view returns(address);
    function get_asset_base_symbol(string memory symbol) external view returns(string memory);
    function get_asset_oracle_symbol(string memory symbol) external view returns(string memory);
}