// payment router + mint bridge
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ModelNFT.sol";
import "./ImageNFT.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Marketplace is Ownable {
    ModelNFT public modelNFT;
    ImageNFT public imageNFT;
    uint96 public platformFeeBps = 500; // e.g., 5%

    address public treasury;

    event ImagePurchased(uint256 modelId, uint256 imageId, address buyer, string imageCID, uint256 amount);

    constructor(address _modelNFT, address _imageNFT, address _treasury)  Ownable(msg.sender) {
        modelNFT = ModelNFT(_modelNFT);
        imageNFT = ImageNFT(_imageNFT);
        treasury = _treasury;
    }

    // Simplified flow: buyer pays ETH (or ERC20 in extension). Off-chain inference returns ipfsCID+proof.
    function buyAndMintWithETH(uint256 modelId, string calldata ipfsCID) external payable {
        uint256 amount = msg.value;
        require(amount > 0, "pay amount");
        // compute fees
        uint256 platformFee = (amount * platformFeeBps) / 10000;
        uint256 remaining = amount - platformFee;

        // distribute royalties to model owner (creator) using ERC2981 standard
        (address royaltyReceiver, uint256 royaltyAmount) = modelNFT.royaltyInfo(modelId, remaining);
        if (royaltyAmount > 0) {
            remaining -= royaltyAmount;
            payable(royaltyReceiver).transfer(royaltyAmount);
        }

        // distribute co-creator shares if any
        ModelNFT.Model memory m = modelNFT.models(modelId);
        for (uint i = 0; i < m.coCreators.length; i++) {
            uint share = (remaining * m.coShares[i]) / 10000;
            if (share > 0) {
                payable(m.coCreators[i]).transfer(share);
                remaining -= share;
            }
        }

        // remaining goes to model owner (creator)
        address owner = modelNFT.ownerOf(modelId);
        if (remaining > 0) payable(owner).transfer(remaining);

        // platform fee to treasury
        if (platformFee > 0) payable(treasury).transfer(platformFee);

        // Mint ImageNFT to buyer with provided ipfsCID (assume off-chain inference done & proof recorded off-chain)
        uint256 imageId = imageNFT.mintImage(msg.sender, ipfsCID);
        emit ImagePurchased(modelId, imageId, msg.sender, ipfsCID, msg.value);
    }

    // admin getters / setters
    function setPlatformFee(uint96 bps) external onlyOwner { platformFeeBps = bps; }
    function setTreasury(address t) external onlyOwner { treasury = t; }
}
