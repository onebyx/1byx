// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IPriceFeed {

    function setRate(address from, address to, uint rate) external ;
    function getRate(address from,address to) external view returns(uint);
}
