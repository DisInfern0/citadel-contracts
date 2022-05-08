pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract CitadelNFT is 
    ERC721, 
    Ownable, 
    AccessControlEnumerable,
    ERC721Enumerable,
    ERC721Burnable,
    ERC721Pausable 
{
    bytes32 public constant DEV_ROLE = keccak256("DEV_ROLE");
    using SafeMath for uint256;
    uint256 public MAX_CITADEL = 1024;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    string private _baseTokenURI;
    mapping(uint256 => uint256) public level;
    uint256 public MAX_LEVEL = 9;
    bytes32 public _merkleRoot = 0x3d3e1b17235644ae1fbabbdada2fa910e008474cb0d1e9ec310216cd41ed1c35;
    mapping(address => bool) public whitelistClaimed;

    constructor(string memory name, string memory symbol, string memory baseTokenURI) ERC721(name, symbol) {
        _baseTokenURI = baseTokenURI;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(DEV_ROLE, _msgSender());
    }

    /**
     * reserve num citadel for npc game play
     */
    function reserveCitadel(uint256 num) external {     
        require(hasRole(DEV_ROLE, _msgSender()), "must have dev role to reserve");   
        uint i;
        for (i = 0; i < num; i++) {
            _safeMint(msg.sender, _tokenIdCounter.current());
            _tokenIdCounter.increment();
        }
    }

    function getNextTokenId() external view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function mintCitadel(bytes32[] calldata _merkleProof) external {
        require(totalSupply().add(1) <= MAX_CITADEL, "purchase would exceed max supply of citadel nft");
        require(!whitelistClaimed[msg.sender], "address has already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(MerkleProof.verify(_merkleProof, _merkleRoot, leaf), "invalid proof");

        if (totalSupply() < MAX_CITADEL) {
            _safeMint(msg.sender, _tokenIdCounter.current());
            _tokenIdCounter.increment();
            whitelistClaimed[msg.sender] = true;
        }
    }

    function changeLevel(uint256 newLevel, uint256 tokenId) external {
        require(hasRole(DEV_ROLE, _msgSender()), "must have dev role to uplevel citadel");
        require(newLevel <= MAX_LEVEL, "citadel max level 9");
        require(newLevel >= 0, "citadel min level 0");
        level[tokenId] = newLevel;
    }

    function updateBaseURI(string memory baseTokenURI) external {
        require(hasRole(DEV_ROLE, _msgSender()), "must have dev role to update baseTokenURI");
        _baseTokenURI = baseTokenURI;
    }

    function updateMerkleRoot(bytes32 merkleRoot) external {
        require(hasRole(DEV_ROLE, _msgSender()), "must have dev role to update merkle root");
        _merkleRoot = merkleRoot;
    }

    function addDevRole(address account) external virtual {
        require(hasRole(DEV_ROLE, _msgSender()), "must have dev role to add role");
        grantRole(DEV_ROLE, account);
    }

    function pause() external {
        require(hasRole(DEV_ROLE, _msgSender()), "must have dev role to pause");
        _pause();
    }

    function unpause() external {
        require(hasRole(DEV_ROLE, _msgSender()), "must have dev role to unpause");
        _unpause();
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function getMerkleRoot() external view returns (bytes32) {
        require(hasRole(DEV_ROLE, _msgSender()), "must have dev role to get merkle root");
        return _merkleRoot;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlEnumerable, ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}