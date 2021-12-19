import { ethers } from "hardhat";

async function main() {
  const CompaignFactory = await ethers.getContractFactory("CompaignFactory");
  const compaignFactory = await CompaignFactory.deploy();

  await compaignFactory.deployed();

  console.log("CompaignFactory deployed to:", compaignFactory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
