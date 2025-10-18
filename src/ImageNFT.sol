// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract ImageNFT is ERC721, Ownable {
    uint256 public nextId;
    mapping(uint256 => string) public tokenCID;

    event ImageMinted(uint256 indexed id, address indexed owner, string ipfsCID);

    constructor() ERC721("ImageNFT", "IMG") Ownable(msg.sender) {}


    function mintImage(address to, string calldata ipfsCID) external returns (uint256) {
        uint256 id = ++nextId;
        tokenCID[id] = ipfsCID;
        _mint(to, id);
        emit ImageMinted(id, to, ipfsCID);
        return id;
    }
}
