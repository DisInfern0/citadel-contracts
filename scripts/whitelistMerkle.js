const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

whitelist = [
  "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266",
  "0x56DBD1086A7c9E3A3Aca1414fBA45a99d20Ef05F",
  "0x29d7d1dd5b6f9c864d9db560d72a247c178ae86b",
  "0xe4fEB387cB1dAff4bf9108581B116e5FA737Bea2",
  "0xDFd5293D8e347dFe59E90eFd55b2956a1343963d",
  "0x1eb026649B6ac698cBad1dA9abD5a8fD54E09132",
  "0x11b58341350ae2b89be7Fadf646F116803611B93",
  "0x70997970c51812dc3a010c7d01b50e0d17dc79c8",
];

const leafNodes = whitelist.map((addr) => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
console.log("whitelist merkle tree\n", merkleTree.toString());

leaf4 = keccak256(whitelist[0]);
const hexProof4 = merkleTree.getHexProof(leaf4);
console.log("hexProof4", hexProof4);

leaf5 = keccak256(whitelist[1]);
const hexProof5 = merkleTree.getHexProof(leaf5);
console.log("hexProof5", hexProof5);

leaf6 = keccak256(whitelist[2]);
const hexProof6 = merkleTree.getHexProof(leaf6);
console.log("hexProof6", hexProof6);

leaf7 = keccak256(whitelist[3]);
const hexProof7 = merkleTree.getHexProof(leaf7);
console.log("hexProof7", hexProof7);
