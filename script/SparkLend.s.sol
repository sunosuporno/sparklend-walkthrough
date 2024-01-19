//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "../src/SparkLend.sol";

contract SparkLendScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        SparkLendIntegration sparkLendIntegration = new SparkLendIntegration(
            0xC13e21B648A5Ee794902342038FF3aDAB66BE987,
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
        );
        vm.stopBroadcast();
    }
}
