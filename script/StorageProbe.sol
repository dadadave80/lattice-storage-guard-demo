// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;
import {VaultStorage} from "@demo/VaultLib.sol";

/// @notice Compile-only probe of the imported source type.
contract StorageProbe {
    VaultStorage internal vault;
}
