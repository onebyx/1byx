// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface IAssetTracker {
    function add_asset(string memory, address) external ;
    function get_asset(string memory symbol) external view returns(address);
}