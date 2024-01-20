//SPDX-License-Identifier: MIT
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
    IERC20 public weth;

    function setUp() public {
        sparkLend = new SparkLendIntegration(
            0xC13e21B648A5Ee794902342038FF3aDAB66BE987,
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
        );

        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        deal(address(weth), address(this), 100 ether);
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
    }

    function testWithdraw() public {
        testSupply();

        sparkLend.withdraw(address(weth), 80 ether, address(sparkLend));

        uint balAfter = weth.balanceOf(address(this));

        assertEq(balAfter, 100 ether, "balAfter is not equal to 100 ethers");
    }

    function testBorrow() public {
        testSupply();

        sparkLend.borrow(address(dai), 10 ether, 2, 0, address(sparkLend));

        uint daiBalAfter = dai.balanceOf(address(this));

        assertEq(
            daiBalAfter,
            10 ether,
            "usdcBalAfter is not equal to 10 ethers"
        );
    }

    function testRepay() public {
        testBorrow();

        dai.approve(address(sparkLend), 10 ether);
        sparkLend.repay(address(dai), 10 ether, 2, address(sparkLend));

        uint daiBalAfter = dai.balanceOf(address(this));

        assertEq(daiBalAfter, 0 ether, "daiBalAfter is not equal to 0 ethers");
    }
}
