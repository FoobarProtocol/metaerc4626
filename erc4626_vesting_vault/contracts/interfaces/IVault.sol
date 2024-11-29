// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IVault - Interface for the Vault contract
/// @notice This interface defines the essential functions for the Vault contract
interface IVault {
    
    /// @notice Allows a user to deposit a specified amount into the vault
    /// @param amount The amount to be deposited
    function deposit(uint256 amount) external;

    /// @notice Allows a user to withdraw a specified amount from the vault
    /// @param amount The amount to be withdrawn
    function withdraw(uint256 amount) external;

    /// @notice Retrieves the balance of a specified address
    /// @param account The address whose balance is to be retrieved
    /// @return The balance of the specified address
    function getBalance(address account) external view returns (uint256);

    /// @notice Retrieves the vesting schedule of a specified address
    /// @param account The address whose vesting schedule is to be retrieved
    /// @return The vesting schedule of the specified address
    function getVestingSchedule(address account) external view returns (VestingSchedule);
}

/// @title VestingSchedule - Struct for representing a vesting schedule
/// @notice This struct is used to represent the vesting schedule of an account
struct VestingSchedule {
    uint256 startTime;
    uint256 cliff;
    uint256 duration;
    uint256 interval;
}
