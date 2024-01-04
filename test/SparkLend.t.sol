pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import "forge-std/StdUtils.sol";
import "forge-std/console.sol";
import {SparkLendIntegration} from "../src/SparkLend.sol";
import {IERC20} from "../src/IERC20.sol";
import {IPool} from "../src/IPool.sol";

contract SparkLendIntegrationTest is Test {
    SparkLendIntegration public sparkLend;
    IERC20 public dai;

    function setUp() public {
        sparkLend = new SparkLendIntegration(
            0x8115366Ca7Cf280a760f0bC0F6Db3026e2437115,
            0x6B175474E89094C44Da98b954EedeAC495271d0F
        );

        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        deal(address(dai), address(this), 100 ether);
    }

    function testDeposit() public {
        uint balBefore = dai.balanceOf(address(this));
        console.log("balBefore", balBefore);

        deal(address(dai), address(this), 10 ether);

        // dai.deposit{value: 100}();

        uint balAfter = dai.balanceOf(address(this));
        console.log("balAfter", balAfter);
    }

    function testSupply() public {
        uint balBefore = dai.balanceOf(address(this));
        console.log("balBefore", balBefore);

        dai.approve(address(sparkLend), 80 ether);
        sparkLend.supply(address(dai), 80 ether, address(0x078), 0);

        uint balAfter = dai.balanceOf(address(this));
        console.log("balAfter", balAfter);

        assertLt(balAfter, balBefore, "balBefore is not greater than balAfter");

        (
            uint256 totalCollateralETH,
            uint256 totalDebtETH,
            uint256 availableBorrowsETH,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        ) = sparkLend.getUserAccountData(address(this));
    }
}

// forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/UIHGVcR4gARi_2y0C5WFBNQvEKyqmDak --match-path test/SparkLend.t.sol -vvvv
