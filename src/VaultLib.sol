// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

bytes32 constant VAULT_STORAGE_SLOT = 0x63a53815bfe44493ce6b602e02e6290b640027f8562f45263d0368a4174da300;

/// @custom:storage-location erc7201:example.storage.Vault
struct VaultStorage {
    uint256 total;
    mapping(address => uint256) balances;
    uint256 epoch;
}

/// @title VaultLib
/// @notice Storage-only fixture for demonstrating the reusable CI guard; no assets are held.
library VaultLib {
    function store() internal pure returns (VaultStorage storage s) {
        assembly { s.slot := VAULT_STORAGE_SLOT }
    }
}
