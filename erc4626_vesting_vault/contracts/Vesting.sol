// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IVesting.sol";

/// @title Vesting - Contract to handle vesting logic
/// @notice This contract calculates vested and unvested amounts for accounts
contract Vesting is IVesting, Ownable {
    struct VestingSchedule {
        uint256 startTime;
        uint256 cliff;
        uint256 duration;
        uint256 interval;
    }

    mapping(address => VestingSchedule) private vestingSchedules;
    mapping(address => uint256) private vestedAmounts;

    /// @notice Calculates the vested amount for a specified address
    /// @param account The address for which to calculate the vested amount
    /// @return The vested amount for the specified address
    function calculateVestedAmount(address account) external view override returns (uint256) {
        VestingSchedule memory schedule = vestingSchedules[account];
        if (block.timestamp < schedule.startTime + schedule.cliff) {
            return 0;
        }
        uint256 elapsedTime = block.timestamp - schedule.startTime;
        uint256 totalVestingTime = schedule.duration;
        if (elapsedTime >= totalVestingTime) {
            return vestedAmounts[account];
        }
        uint256 vested = (vestedAmounts[account] * elapsedTime) / totalVestingTime;
        return vested;
    }

    /// @notice Calculates the unvested amount for a specified address
    /// @param account The address for which to calculate the unvested amount
    /// @return The unvested amount for the specified address
    function calculateUnvestedAmount(address account) external view override returns (uint256) {
        uint256 totalAmount = vestedAmounts[account];
        uint256 vested = calculateVestedAmount(account);
        return totalAmount - vested;
    }

    /// @notice Updates the vesting parameters for a specified address
    /// @param account The address for which to update the vesting parameters
    /// @param startTime The start time of the vesting schedule
    /// @param cliff The cliff period of the vesting schedule
    /// @param duration The total duration of the vesting schedule
    /// @param interval The interval at which vesting occurs
    function updateVestingParameters(
        address account,
        uint256 startTime,
        uint256 cliff,
        uint256 duration,
        uint256 interval
    ) external onlyOwner {
        require(account != address(0), "Invalid account address");
        require(duration > 0, "Duration must be greater than zero");
        require(interval > 0, "Interval must be greater than zero");

        vestingSchedules[account] = VestingSchedule({
            startTime: startTime,
            cliff: cliff,
            duration: duration,
            interval: interval
        });
    }

    /// @notice Internal function to calculate linear vesting
    /// @param startTime The start time of the vesting schedule
    /// @param cliff The cliff period of the vesting schedule
    /// @param duration The total duration of the vesting schedule
    /// @return The calculated vested amount
    function linearVestingCalculation(
        uint256 startTime,
        uint256 cliff,
        uint256 duration
    ) internal view returns (uint256) {
        if (block.timestamp < startTime + cliff) {
            return 0;
        }
        uint256 elapsedTime = block.timestamp - startTime;
        if (elapsedTime >= duration) {
            return vestedAmounts[msg.sender];
        }
        uint256 vested = (vestedAmounts[msg.sender] * elapsedTime) / duration;
        return vested;
    }
}
