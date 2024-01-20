// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IPool.sol";
import "./IERC20.sol";

contract SparkLendIntegration {
    IPool public pool;
    IERC20 public dai;
    IERC20 public weth;

    constructor(address _pool, address _dai, address _weth) {
        pool = IPool(_pool);
        dai = IERC20(_dai);
        weth = IERC20(_weth);
        // poolAddress = _pool;
    }

    function supply(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode
    ) external {
        require(
            IERC20(asset).transferFrom(msg.sender, address(this), amount),
            "Failed to transfer DAI to SparkLendIntegration"
        );
        require(
            IERC20(asset).approve(address(pool), amount),
            "Failed to approve DAI for Pool contract"
        );
        pool.supply(asset, amount, onBehalfOf, referralCode);
    }

    function withdraw(
        address asset,
        uint256 amount,
        address to
    ) external returns (uint256) {
        pool.withdraw(asset, amount, to);
        IERC20(asset).transfer(msg.sender, amount);
    }

    function borrow(
        address asset,
        uint256 amount,
        uint256 interestRateMode,
        uint16 referralCode,
        address onBehalfOf
    ) external {
        pool.borrow(asset, amount, interestRateMode, referralCode, onBehalfOf);
        IERC20(asset).transfer(msg.sender, amount);
    }

    function repay(
        address asset,
        uint256 amount,
        uint256 rateMode,
        address onBehalfOf
    ) external returns (uint256) {
        require(
            IERC20(asset).transferFrom(msg.sender, address(this), amount),
            "Failed to transfer DAI to SparkLendIntegration"
        );

        require(
            IERC20(asset).approve(address(pool), amount),
            "Failed to approve DAI for Pool contract"
        );
        pool.repay(asset, amount, rateMode, onBehalfOf);
    }

    function getUserAccountData(
        address user
    )
        external
        view
        returns (
            uint256 totalCollateralBase,
            uint256 totalDebtBase,
            uint256 availableBorrowsBase,
            uint256 currentLiquidationThreshold,
            uint256 ltv,
            uint256 healthFactor
        )
    {
        // your contract logic
        return pool.getUserAccountData(user);
    }
}
