//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "../src/SparkLend.sol";

contract SparkLendScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        SparkLendIntegration sparkLendIntegration = new SparkLendIntegration(
            0x26ca51Af4506DE7a6f0785D20CD776081a05fF6d,
            0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844
        );
        vm.stopBroadcast();
    }
}
