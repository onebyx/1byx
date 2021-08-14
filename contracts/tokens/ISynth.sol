// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface ISynth {
    
    function issue(address account, uint amount) external;

    function burn(address account, uint amount) external;

}