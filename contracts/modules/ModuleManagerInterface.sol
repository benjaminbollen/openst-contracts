pragma solidity ^0.5.0;

import "./ModuleManagerInterface.sol";

/**
 *  @title ModuleManagerInterface provides interface for Gnosis SAFE ModuleManager
 */
contract ModuleManagerInterface {

    enum Operation {
        Call,
        DelegateCall,
        Create
    }

    /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
    /// @param to Destination address of module transaction.
    /// @param value Ether value of module transaction.
    /// @param data Data payload of module transaction.
    /// @param operation Operation type of module transaction.
    function execTransactionFromModule(address to, uint256 value, bytes data, Operation operation)
        external
        returns (bool success);

    /// @dev Returns array of modules.
    /// @return Array of modules.
    function getModules()
        external
        view
        returns (address[]);
}
