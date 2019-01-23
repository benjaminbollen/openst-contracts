pragma solidity ^0.5.0;

import "./Module.sol";

/**
 *  @title DelayedRecovery allows 
 */
contract DelayedRecoveryModule is Module {

    string public constant NAME = "Delayed Recovery Module";
    string public constant VERSION = "0.1.0";

    bytes32 public constant SENTINEL_PROCEDURES = bytes32(0x1);

    struct DelayedRecovery {
        uint256 initialisedBlockNumber;
        uint256 executableBlockNumber;
        address prevOwner;
        address oldOwner;
        address newOwner;
    }

    uint256 public blockDelay;
    address public recoveryInitiator;

    // TODO: [ben] make linked list so that we can iterate through the history
    // isExecuted mapping maps data hash to execution status.
    mapping (bytes32 => bool) public isExecuted;

    // TODO: consider value of keeping history of recovery procedures in contract state.
    // mapping (bytes32 => DelayedRecovery) public recoveryTrace;
    
    // only a single active recovery procedure can be active at a time.
    DelayedRecovery activeRecoveryProcedure;

    modifier onlyRecoveryInitiator() {
        require(imsg.sender == recoveryInitiator, "Method can only be called by recovery");
        _;
    }

    // TODO [ben]: implement mastercopy / factory setup for module
    /// @dev Setup function sets initial storage of contract.
    /// @param _recoveryInitiator trusted address that can initiate a recovery procedure.
    /// @param _blockDelay Required number of blocks before a recovery can be executed.
    function setup(uint256 _blockDelay, address _recoveryInitiator)
        public
    {
        require(_blockDelay >= 4 * 84600, "Block delay cannot be less than 4 * 84600 blocks");
        require(_recoveryInitiator != address(0), "Recovery initiator cannot be zero");
        setManager();
        blockDelay = _blockDelay;
        recoveryInitiator = _recoveryInitiator;
    }

    /// @dev Returns if Safe transaction is a valid owner replacement transaction.
    /// @param prevOwner Owner that pointed to the owner to be replaced in the linked list
    /// @param oldOwner Owner address to be replaced.
    /// @param newOwner New owner address.
    /// @return Returns if transaction can be executed.
    function initiateRecoveryAccess(address prevOwner, address oldOwner, address newOwner)
        public
        onlyRecoveryInitiator
    {
        bytes memory data = abi.encodeWithSignature("swapOwner(address,address,address)", prevOwner, oldOwner, newOwner);
        bytes32 dataHash = getDataHash(data);
        require(!isExecuted[dataHash], "Recovery already executed");
        require(isConfirmedByRequiredFriends(dataHash), "Recovery has not enough confirmations");
        isExecuted[dataHash] = true;
        require(manager.execTransactionFromModule(address(manager), 0, data, Enum.Operation.Call), "Could not execute recovery");
    }

    /// @dev Returns if Safe transaction is a valid owner replacement transaction.
    /// @param prevOwner Owner that pointed to the owner to be replaced in the linked list
    /// @param oldOwner Owner address to be replaced.
    /// @param newOwner New owner address.
    /// @return Returns if transaction can be executed.
    function recoverAccess(address prevOwner, address oldOwner, address newOwner)
        public
        onlyRecoveryInitiator
    {
        bytes memory data = abi.encodeWithSignature("swapOwner(address,address,address)", prevOwner, oldOwner, newOwner);
        bytes32 dataHash = getDataHash(data);
        require(!isExecuted[dataHash], "Recovery already executed");
        require(isConfirmedByRequiredFriends(dataHash), "Recovery has not enough confirmations");
        isExecuted[dataHash] = true;
        require(manager.execTransactionFromModule(address(manager), 0, data, Enum.Operation.Call), "Could not execute recovery");
    }

    /// @dev Returns if Safe transaction is a valid owner replacement transaction.
    /// @param prevOwner Owner that pointed to the owner to be replaced in the linked list
    /// @param oldOwner Owner address to be replaced.
    /// @param newOwner New owner address.
    /// @return Returns if transaction can be executed.
    function abortRecoveryAccess(address prevOwner, address oldOwner, address newOwner)
        public
        authorized
    {
        require(
            msg.sender == address(manager) || msg.sender == recoveryInitiator,
            "Only the owner or the recovery initiator can abort a recovery procedure"
        );
        bytes memory data = abi.encodeWithSignature("swapOwner(address,address,address)", prevOwner, oldOwner, newOwner);
        bytes32 dataHash = getDataHash(data);
        require(!isExecuted[dataHash], "Recovery already executed");
        require(isConfirmedByRequiredFriends(dataHash), "Recovery has not enough confirmations");
        isExecuted[dataHash] = true;
        require(manager.execTransactionFromModule(address(manager), 0, data, Enum.Operation.Call), "Could not execute recovery");
    }

    /// @dev Returns if Safe transaction is a valid owner replacement transaction.
    /// @param dataHash Data hash.
    /// @return Confirmation status.
    function isActive(bytes32 dataHash)
        public
        view
        returns (bool)
    {
        if (activeRecoveryProcedure == 0x01) return false;
        if (recoveryTrace[datahash] == 0) return false;
        if (dataHash != activeRecoveryProcedure
            && recoveryTrace[datahas]);
    }

    /// @dev Returns hash of data encoding owner replacement.
    /// @param data Data payload.
    /// @return Data hash.
    function getDataHash(bytes memory data)
        public
        pure
        returns (bytes32)
    {
        return keccak256(data);
    }
}
