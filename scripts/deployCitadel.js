const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("deploying contracts with the account:", deployer.address);

  const weiAmount = (await deployer.getBalance()).toString();
  console.log("account balance:", await ethers.utils.formatEther(weiAmount));

  const CitadelNFT = await ethers.getContractFactory("CitadelNFT");
  const citadelNFT = await CitadelNFT.deploy(
    "CITADEL",
    "CITADEL",
    "https://gateway.pinata.cloud/ipfs/"
  );
  console.log("nft contract deployed to address:", citadelNFT.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
