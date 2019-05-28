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

import "../token/TokenRules.sol";
import "./ExtensionRuleI.sol";

contract Sequencer {

    struct Transfers {
        address[] to;
        uint256[] amount;
    }

    bytes4 public constant EXTEND_CALLPREFIX = bytes4(
        keccak256("extend(address[],uint256[])")
    );

    function sequence(
        TokenRules _tokenRules, // make TokenRulesI interface
        address _baseRule,
        bytes calldata _data,
        ExtensionRuleI[] calldata _extension // CAN be empty
    )
        external
        payable
    {
        // redundant, but as a mental note
        address from = msg.sender;

        // call base rule
        bytes memory returnData;
        bool executionStatus;
        byte statusCode;
        address[] memory to;
        uint256[] memory amount;
        // solium-disable-next-line security/no-call-value
        (executionStatus, returnData) = _baseRule.call.value(msg.value)(_data);
        // Before continuing with extension rules, the base rule must succeed
        require(executionStatus, "Base rule must execute successfully.");

        // decode return data
        (statusCode, to, amount) = abi.decode(returnData, (byte, address[], uint256[]));

        // TODO: evaluate and implement statusCode EIP-1066
        require(statusCode == 0x01, "Status code must return success.");

        // call all extensions with interface
        for (uint256 i = 0; i < _extension.length(); i++) {
            
            (statusCode, to, amount) = _extension[i].extend(to, amount);
            require(statusCode == 0x01, "Status code must return success.");
        }

        // call token rules
        tokenRules.executeTransfers(from, to, amount);
    }
}