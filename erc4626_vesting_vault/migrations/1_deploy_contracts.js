## migrations/1_deploy_contracts.js

const Vault = artifacts.require("Vault");
const Vesting = artifacts.require("Vesting");

module.exports = async function (deployer, network, accounts) {
  // Deploy the Vesting contract first
  await deployer.deploy(Vesting);
  const vestingInstance = await Vesting.deployed();

  // Deploy the Vault contract with the address of the deployed Vesting contract
  await deployer.deploy(Vault, vestingInstance.address);
  const vaultInstance = await Vault.deployed();

  // Set up initial roles and parameters if necessary
  const adminRole = web3.utils.keccak256("ADMIN_ROLE");

  // Assuming the first account is the deployer and should have admin role
  await vaultInstance.grantRole(adminRole, accounts[0]);

  console.log("Contracts deployed successfully!");
  console.log("Vesting Contract Address:", vestingInstance.address);
  console.log("Vault Contract Address:", vaultInstance.address);
};
