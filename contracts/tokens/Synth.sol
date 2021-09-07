// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/token/ERC20/ERC20.sol";
import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";
import "./IAssetTracker.sol";

contract Synth is Ownable, ERC20 {
    // Currency key which identifies this Synth to the Synthetix system
    bytes32 public currencyKey;
    uint8 public constant DECIMALS = 18;
    string public baseSymbol;
    string public oracleSymbol;

    // todo add fee pool, exchanger, staker address 

    /* ========== CONSTRUCTOR ========== */

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        string memory _baseSymbol,
        string memory _oracleSymbol,
        uint _totalSupply,
        IAssetTracker _AssetTracker
    )
        public
        ERC20(_tokenName, _tokenSymbol )
        Ownable(){
            _AssetTracker.add_asset(_tokenSymbol,address(this),_baseSymbol,_oracleSymbol);
            baseSymbol = _baseSymbol;
            oracleSymbol = _oracleSymbol;
        }

    function issue(address account, uint amount) external onlyInternalContracts {
        _mint(account, amount);
    }

    function burn(address account, uint amount) external onlyInternalContracts {
        _burn(account, amount);
    }

    /* ========== MODIFIERS ========== */

    modifier onlyInternalContracts() {
        // todo add fee pool , exchanger, staker address

        require(true, "Only FeePool, Exchanger or staker contracts allowed");
        _;
    }

    /* ========== EVENTS ========== */
    event Issued(address indexed account, uint value);
    event Burned(address indexed account, uint value);

}