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

import "../organization/contracts/Organized.sol";
import "../organization/contracts/OrganizationInterface.sol";

contract BaseRule is Organized {

    bool public enabled;
    address public sequencer;

    modifier RuleEnabled() {
        require
    }

    constructor(
        bool _enabled
    )
        public
    {
        enabled = _enabled;
    }

    function continue
    (
        address _from,
        address[] calldata _transfersTo,
        uint256[] calldata _transfersAmount,
        address[] calldata _sequence
    ) 
        internal
    {
        
    }

    function enableRule(bool _enable) external OnlyOrganization {
        enabled = _enable;
    }
}