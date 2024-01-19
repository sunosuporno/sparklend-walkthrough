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
    IERC20 public usdc;
    IERC20 public weth;

    function setUp() public {
        sparkLend = new SparkLendIntegration(
            0xC13e21B648A5Ee794902342038FF3aDAB66BE987,
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
        );

        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        deal(address(dai), address(this), 100 ether);
        deal(address(weth), address(this), 100 ether);
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
        uint balBefore = weth.balanceOf(address(this));
        console.log("balBefore", balBefore);

        weth.approve(address(sparkLend), 80 ether);
        sparkLend.supply(
            address(weth),
            80 ether,
            address(address(sparkLend)),
            0
        );

        uint balAfter = weth.balanceOf(address(this));
        console.log("balAfter", balAfter);

        assertLt(balAfter, balBefore, "balBefore is not greater than balAfter");

        vm.roll(block.number + 10);

        (
            uint256 totalCollateralETH,
            uint256 totalDebtETH,
            uint256 availableBorrowsETH,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        ) = sparkLend.getUserAccountData(address(sparkLend));
        console.log("totalCollateralETH", totalCollateralETH);
        console.log("totalDebtETH", totalDebtETH);
        console.log("availableBorrowsETH", availableBorrowsETH);
        console.log("currentLiquidationThreshold", currentLiquidationThreshold);
        console.log("ltv", ltv);
        console.log("healthFactor", healthFactor);

        // sparkLend.withdraw(address(dai), 80 ether, address(sparkLend));

        // uint balFinal = dai.balanceOf(address(this));
        // console.log("balFinal", balFinal);

        // assertGt(balFinal, balAfter, "balAfter is not greater than balBefore");
    }

    function testWithdraw() public {
        testSupply();

        sparkLend.withdraw(address(dai), 80 ether, address(sparkLend));

        uint balAfter = dai.balanceOf(address(this));

        assertEq(balAfter, 100 ether, "balAfter is not equal to 100 ethers");
    }

    function testBorrow() public {
        testSupply();

        // uint poolDaiBal = dai.balanceOf(
        //     address(0xC13e21B648A5Ee794902342038FF3aDAB66BE987)
        // );
        // console.log("poolDaiBal", poolDaiBal);
        // deal(
        //     address(dai),
        //     address(0xC13e21B648A5Ee794902342038FF3aDAB66BE987),
        //     200 ether
        // );
        // uint newPoolDaiBal = dai.balanceOf(
        //     address(0xC13e21B648A5Ee794902342038FF3aDAB66BE987)
        // );
        // console.log("newPoolDaiBal", newPoolDaiBal);
        uint daiBalBefore = dai.balanceOf(address(this));

        // vm.roll(block.number + 10);
        sparkLend.borrow(address(dai), 10 ether, 1, 0, address(sparkLend));

        uint daiBalAfter = dai.balanceOf(address(this));

        assertEq(
            daiBalAfter,
            10 ether,
            "usdcBalAfter is not equal to 10 ethers"
        );
    }
}

// forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/UIHGVcR4gARi_2y0C5WFBNQvEKyqmDak --match-path test/SparkLend.t.sol -vvvv
