// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "smartcontractkit/chainlink-brownie-contracts@0.2.1/contracts/src/v0.8/ChainlinkClient.sol";
import "OpenZeppelin/openzeppelin-contracts@4.2.0/contracts/access/Ownable.sol";
import "./../oracle/IPriceFeed.sol";
import "./../tokens/IAssetTracker.sol";


contract APIConsumer is ChainlinkClient , Ownable{
    using Chainlink for Chainlink.Request;

    IPriceFeed public pf;
    IAssetTracker public at;
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    mapping(bytes32 => string) public req_to_asset;
    
    constructor(IPriceFeed _pf,IAssetTracker _at) public Ownable(){
        setChainlinkToken(0xa36085F69e2889c224210F603D836748e7dC0088);
        oracle = 0x97eE9dAA9dDaFEf649680670Ca5A9a69338AeE76;
        jobId = "1c4635c91b204d67aee26a4fd889d35b";
        fee = 10 ** 16; // 0.01 LINK
        pf= _pf;
        at= _at;
    }
    
    function requestAssetPrice(string memory symbol) public returns (bytes32 requestId) 
    {   
        string memory oracle_symbol = at.get_asset_oracle_symbol(symbol);
        require(keccak256(abi.encodePacked(oracle_symbol)) != keccak256(abi.encodePacked(""))," oracle not assigned ");

        
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        request.add("get", "https://onebyxoracle.herokuapp.com/get_assets");
        
        string[] memory path = new string[](1);

        path[0] = oracle_symbol;
        request.addStringArray("path", path);

        // Multiply the result by 10000000000 to remove decimals
        request.addInt("times", 10000000000);
        // Sends the request
        bytes32 request_id = sendChainlinkRequestTo(oracle, request, fee);
        req_to_asset[request_id] = symbol;
        return request_id;
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function fulfill(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId)
    {
        string memory symbol = req_to_asset[_requestId];
        if(keccak256(abi.encodePacked(symbol)) != keccak256(abi.encodePacked(""))){
            pf.setRate(at.get_asset(at.get_asset_base_symbol(symbol)),at.get_asset(symbol), _price);
        }
    }
}