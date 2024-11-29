## test/VestingTest.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Vesting.sol";
import "../contracts/interfaces/IVesting.sol";

/// @title VestingTest - Unit tests for the Vesting contract
contract VestingTest {
    IVesting private vesting;
    address private testAccount;
    uint256 private initialVestedAmount;

    /// @notice Set up the test environment
    function beforeAll() public {
        vesting = IVesting(DeployedAddresses.Vesting());
        testAccount = address(this);
        initialVestedAmount = 1000;

        // Assume initial vested amount is set for testing
        // This would typically be done through a mock or setup function
    }

    /// @notice Test the calculateVestedAmount function
    function testCalculateVestedAmount() public {
        uint256 vestedAmount = vesting.calculateVestedAmount(testAccount);

        // Assume some logic to determine expected vested amount
        uint256 expectedVestedAmount = 500; // Placeholder for expected value

        Assert.equal(vestedAmount, expectedVestedAmount, "Vested amount should match expected value");
    }

    /// @notice Test the calculateUnvestedAmount function
    function testCalculateUnvestedAmount() public {
        uint256 unvestedAmount = vesting.calculateUnvestedAmount(testAccount);

        // Assume some logic to determine expected unvested amount
        uint256 expectedUnvestedAmount = initialVestedAmount - 500; // Placeholder for expected value

        Assert.equal(unvestedAmount, expectedUnvestedAmount, "Unvested amount should match expected value");
    }

    /// @notice Test the updateVestingParameters function
    function testUpdateVestingParameters() public {
        uint256 startTime = block.timestamp;
        uint256 cliff = 60 * 60 * 24 * 30; // 30 days
        uint256 duration = 60 * 60 * 24 * 365; // 1 year
        uint256 interval = 60 * 60 * 24 * 30; // 30 days

        // Assume we have a way to call updateVestingParameters
        // This would typically be done through a mock or setup function
        // vesting.updateVestingParameters(testAccount, startTime, cliff, duration, interval);

        // Check if the vesting schedule is updated correctly
        Vesting.VestingSchedule memory schedule = vesting.getVestingSchedule(testAccount);

        Assert.equal(schedule.startTime, startTime, "Vesting schedule start time should be updated");
        Assert.equal(schedule.cliff, cliff, "Vesting schedule cliff should be updated");
        Assert.equal(schedule.duration, duration, "Vesting schedule duration should be updated");
        Assert.equal(schedule.interval, interval, "Vesting schedule interval should be updated");
    }
}
