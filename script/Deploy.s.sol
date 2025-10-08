// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/ModelNFT.sol";
import "../src/ImageNFT.sol";
import "../src/Marketplace.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        ModelNFT model = new ModelNFT();
        ImageNFT image = new ImageNFT();
        Marketplace market = new Marketplace(address(model), address(image), msg.sender);

        vm.stopBroadcast();
    }
}
