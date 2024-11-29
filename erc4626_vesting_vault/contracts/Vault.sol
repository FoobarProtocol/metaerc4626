## contracts/Vault.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/IVault.sol";
import "./interfaces/IVesting.sol";

/// @title Vault - ERC4626-compliant Vault with vesting schedule
/// @notice This contract allows users to deposit and withdraw tokens with a vesting schedule
contract Vault is IVault, ReentrancyGuard, Ownable, AccessControl {
    using SafeMath for uint256;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    IVesting private vestingContract;
    bool private paused;

    mapping(address => uint256) private balances;

    /// @notice Constructor to set the vesting contract address
    /// @param _vestingContract Address of the vesting contract
    constructor(address _vestingContract) {
        require(_vestingContract != address(0), "Invalid vesting contract address");
        vestingContract = IVesting(_vestingContract);
        _setupRole(ADMIN_ROLE, msg.sender);
        paused = false;
    }

    /// @notice Allows a user to deposit a specified amount into the vault
    /// @param amount The amount to be deposited
    function deposit(uint256 amount) external override nonReentrant {
        require(!paused, "Vault is paused");
        require(amount > 0, "Deposit amount must be greater than zero");

        // Logic to transfer tokens from user to vault
        // Assume a token transfer function is available
        // Example: token.transferFrom(msg.sender, address(this), amount);

        balances[msg.sender] = balances[msg.sender].add(amount);
    }

    /// @notice Allows a user to withdraw a specified amount from the vault
    /// @param amount The amount to be withdrawn
    function withdraw(uint256 amount) external override nonReentrant {
        require(!paused, "Vault is paused");
        require(amount > 0, "Withdraw amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        uint256 vestedAmount = vestingContract.calculateVestedAmount(msg.sender);
        require(vestedAmount >= amount, "Amount exceeds vested balance");

        balances[msg.sender] = balances[msg.sender].sub(amount);

        // Logic to transfer tokens from vault to user
        // Example: token.transfer(msg.sender, amount);
    }

    /// @notice Retrieves the balance of a specified address
    /// @param account The address whose balance is to be retrieved
    /// @return The balance of the specified address
    function getBalance(address account) external view override returns (uint256) {
        return balances[account];
    }

    /// @notice Retrieves the vesting schedule of a specified address
    /// @param account The address whose vesting schedule is to be retrieved
    /// @return The vesting schedule of the specified address
    function getVestingSchedule(address account) external view override returns (VestingSchedule memory) {
        // Assume vestingContract has a function to get vesting schedule
        return vestingContract.getVestingSchedule(account);
    }

    /// @notice Pauses the vault, disabling deposits and withdrawals
    function pause() external onlyRole(ADMIN_ROLE) {
        paused = true;
    }

    /// @notice Unpauses the vault, enabling deposits and withdrawals
    function unpause() external onlyRole(ADMIN_ROLE) {
        paused = false;
    }

    /// @notice Internal function to calculate shares based on amount
    /// @param amount The amount to calculate shares for
    /// @return The calculated shares
    function calculateShares(uint256 amount) internal pure returns (uint256) {
        // Implement share calculation logic
        return amount; // Placeholder
    }

    /// @notice Internal function to calculate assets based on shares
    /// @param shares The shares to calculate assets for
    /// @return The calculated assets
    function calculateAssets(uint256 shares) internal pure returns (uint256) {
        // Implement asset calculation logic
        return shares; // Placeholder
    }
}
