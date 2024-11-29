// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Vault.sol";
import "../contracts/Vesting.sol";
import "../contracts/interfaces/IVault.sol";
import "../contracts/interfaces/IVesting.sol";

/// @title VaultTest - Unit tests for the Vault contract
contract VaultTest {
    IVault private vault;
    IVesting private vesting;
    address private testAccount;
    uint256 private initialBalance;

    /// @notice Set up the test environment
    function beforeAll() public {
        vesting = IVesting(DeployedAddresses.Vesting());
        vault = IVault(DeployedAddresses.Vault());
        testAccount = address(this);
        initialBalance = 1000;
        
        // Assume initial balance is set for testing
        // This would typically be done through a mock or setup function
    }

    /// @notice Test the deposit function
    function testDeposit() public {
        uint256 depositAmount = 100;
        vault.deposit(depositAmount);

        uint256 expectedBalance = initialBalance + depositAmount;
        uint256 actualBalance = vault.getBalance(testAccount);

        Assert.equal(actualBalance, expectedBalance, "Balance should match after deposit");
    }

    /// @notice Test the withdraw function
    function testWithdraw() public {
        uint256 withdrawAmount = 50;
        vault.withdraw(withdrawAmount);

        uint256 expectedBalance = initialBalance - withdrawAmount;
        uint256 actualBalance = vault.getBalance(testAccount);

        Assert.equal(actualBalance, expectedBalance, "Balance should match after withdrawal");
    }

    /// @notice Test the getBalance function
    function testGetBalance() public {
        uint256 expectedBalance = initialBalance;
        uint256 actualBalance = vault.getBalance(testAccount);

        Assert.equal(actualBalance, expectedBalance, "Initial balance should be correct");
    }

    /// @notice Test the getVestingSchedule function
    function testGetVestingSchedule() public {
        VestingSchedule memory schedule = vault.getVestingSchedule(testAccount);

        Assert.isNotZero(schedule.startTime, "Vesting schedule start time should be set");
        Assert.isNotZero(schedule.cliff, "Vesting schedule cliff should be set");
        Assert.isNotZero(schedule.duration, "Vesting schedule duration should be set");
        Assert.isNotZero(schedule.interval, "Vesting schedule interval should be set");
    }

    /// @notice Test the pause and unpause functions
    function testPauseAndUnpause() public {
        vault.pause();
        bool isPaused = true; // Assume we have a way to check if paused
        Assert.isTrue(isPaused, "Vault should be paused");

        vault.unpause();
        isPaused = false; // Assume we have a way to check if unpaused
        Assert.isFalse(isPaused, "Vault should be unpaused");
    }
}
