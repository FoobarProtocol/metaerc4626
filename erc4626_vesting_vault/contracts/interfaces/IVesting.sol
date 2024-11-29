// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IVesting - Interface for the Vesting contract
/// @notice This interface defines the essential functions for the Vesting contract
interface IVesting {
    
    /// @notice Calculates the vested amount for a specified address
    /// @param account The address for which to calculate the vested amount
    /// @return The vested amount for the specified address
    function calculateVestedAmount(address account) external view returns (uint256);

    /// @notice Calculates the unvested amount for a specified address
    /// @param account The address for which to calculate the unvested amount
    /// @return The unvested amount for the specified address
    function calculateUnvestedAmount(address account) external view returns (uint256);
}
