pragma solidity ^0.5.0;

// Copyright 2019 OpenST Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import "./ExtensionRuleI.sol";
import "./FirewalledRule.sol";
import "../token/EIP20TokenInterface.sol";

contract Credit is ExtensionRuleI, FirewalledRule {

    // token
    EIP20TokenInterface public token;

    // allocated budget to credits; keep these tokens locked in the contract
    uint256 public allocatedBudget;

    // Sentinel to mark end of generations linked list.
    uint256 public constant SENTINEL_GENERATIONS = uint256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);

    // Bound the number of maximum (active) generations to keep performance
    uint8 public constant MAX_GENERATIONS = uint8(15);

    // Issuer of credits // use onlyOrganization
    // address public issuer;

    // mapping of generation to credit balances
    mapping(uint256 => mapping(address => uint256)) public credits;

    // linked list of generations expressed by their expiration time in
    // seconds since unix epoch; ordered in increasing expiration time.
    mapping(uint256 => uint256) public generations;

    // whitelist of destination addresses [under consideration; OPTIONAL]

    // use Organization instead
    modifier onlyIssuer {
        require(
            organization.isOrganization(msg.sender),
            "Only issuer can call this function."
        );
        _;
    }

    // function constructor

    function extend
    (
        address _from,
        address[] calldata _transfersTo,
        address[] calldata _transfersAmount
    )
        external
        returns
    (
        byte statusCode_, // EIP-1066, in first step just pass success or failure
        address[] memory transfersTo_,
        address[] memory transfersAmount_
    )
    {

    }

    // insert new generation only in correct ordered position in linked list.
    function createGeneration(uint256 _expirationTime, uint256 _futureGeneration)
        external
        onlyIssuer
        returns (bool)
    {
        // cannot be SENTINEL; cannot be added already
        // insert generation only at correct ordered position
        // respect max length
    }

    // function pruneGeneration

    // allocate new credit to beneficiary assigned to a generation
    function allocateCredit(uint256 _generation, address _holder, uint256 _amount)
        external
        onlyIssuer
        // returns (bool) // what should it return?
    {
        uint256 balance = token.balanceOf(this); // get the token balance
        assert(balance >= allocatedBudget);
        require(balance - allocatedBudget >= _amount,
            "Insufficient balance to allocate credit.");
        
    }




    // creates complications, ignore
    // // explicitly track tokens deposited by issuer, to ensure credits are only allocated
    // // with the token budget provided by issuer
    // function depositTokens(uint256 _amount)
    //     external
    //     onlyIssuer
    //     // returns (bool) // ?
    // {
        
    //     require(token.transferFrom(msg.sender, address(this), _amount);
    // }

    // prevent locked tokens in this contract with a general transfer function
    function transferTokens(EIP20TokenInterface _token, address _to, uint256 _amount)
        external
        onlyOrganization
    {
        // if _token != token, there are no restrictions
        // if _token = token, only unallocated tokens can be transferred, 
    }
}