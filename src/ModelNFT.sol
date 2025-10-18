// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/token/common/ERC2981.sol";

contract ModelNFT is ERC721, ERC2981, Ownable {
    uint256 public nextId;
    struct Model {
        string ipfsCID; // model weights / metadata
        address[] coCreators;
        uint16[] coShares; // basis points per co-creator, sum <= 10000
        uint96 creatorRoyaltyBps; // royalty on outputs (e.g., 500 = 5%)
    }
    mapping(uint256 => Model) public models;

    event ModelMinted(uint256 indexed id, address indexed creator, string ipfsCID);

    constructor() ERC721("ModelNFT", "MODEL") Ownable(msg.sender) {}


    function mintModel(
        address to,
        string calldata ipfsCID,
        address[] calldata coCreators,
        uint16[] calldata coShares,
        uint96 creatorRoyaltyBps
    ) external returns (uint256) {
        require(coCreators.length == coShares.length, "len mismatch");
        uint256 total;
        for (uint i=0;i<coShares.length;i++) total += coShares[i];
        require(total <= 10000, "shares > 100%");
        uint256 id = ++nextId;
        models[id] = Model({ipfsCID: ipfsCID, coCreators: coCreators, coShares: coShares, creatorRoyaltyBps: creatorRoyaltyBps});
        _mint(to, id);
        // set royalty at token level (to contract owner or to `to` - we leave to owner here)
        _setTokenRoyalty(id, to, creatorRoyaltyBps);
        emit ModelMinted(id, to, ipfsCID);
        return id;
    }

    // required overrides
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
