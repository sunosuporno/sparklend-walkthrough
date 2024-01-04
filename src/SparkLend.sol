// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IPool.sol";
import "./IERC20.sol";

contract SparkLendIntegration {
    IPool public pool;
    IERC20 public dai;

    // address public poolAddress;

    constructor(address _pool, address _dai) {
        pool = IPool(_pool);
        dai = IERC20(_dai);
        // poolAddress = _pool;
    }

    // function supply(
    //     address asset,
    //     uint256 amount,
    //     address onBehalfOf,
    //     uint16 referralCode
    // ) external {
    //     //your contract logic
    //     pool.supply(asset, amount, onBehalfOf, referralCode);
    // }

    function supply(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external {
        // To ensure that the SparkLendIntegration contract has the necessary approvals
        require(
            dai.transferFrom(msg.sender, address(this), amount),
            "Failed to transfer DAI to SparkLendIntegration"
        );

        // To call the pool contract's supply function directly
        require(
            dai.approve(address(pool), amount),
            "Failed to approve DAI for Pool contract"
        );
        pool.supply(asset, amount, onBehalfOf, referralCode);
    }

    function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external returns (uint256) {
        // your contract logic
        pool.withdraw(asset, amount, to);
    }

    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external {
        // your contract logic
        pool.borrow(asset, amount, interestRateMode, referralCode, onBehalfOf);
    }

    function repay(
        address asset,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external returns (uint256) {
        // your contract logic

        pool.repay(asset, amount, rateMode, onBehalfOf);
    }

    function getUserAccountData(
        address user
    )
        external
        view
        returns (
            uint256 totalCollateralETH,
            uint256 totalDebtETH,
            uint256 availableBorrowsETH,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        // your contract logic
        pool.getUserAccountData(user);
    }
}
