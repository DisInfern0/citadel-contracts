pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/ownable.sol";

contract CitadelRaffle is Ownable {
    uint256 public MIN = 0;
    uint256 public MAX = 0;

    constructor() {
    }

    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
    }

    function updateParameters(uint256 _min, uint256 _max) public onlyOwner {
        MIN = _min;
        MAX = _max;
    }

    function raffle() public onlyOwner {
        uint256 random = random();
        uint256 winner = random % (MAX - MIN + 1) + MIN;

        return winner;
    }
}