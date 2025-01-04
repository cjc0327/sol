// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract Bank {
    // 状态变量
    address public immutable owner;
    // 事件
    event Deposit(address _ads, uint256 amount);
    event Withdraw(uint256 amount);
    // receive
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    // 构造函数
    constructor() payable {
        owner = msg.sender;
    }
    // 方法
    function withdraw() external {
        require(msg.sender == owner, "Not Owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
    function withdrawERC20(address token, uint256 amount) external {
        require(msg.sender == owner, "Not Owner");
        IERC20 erc20 = IERC20(token);
        uint256 balance = erc20.balanceOf(address(this));
        require(amount <= balance, "Insufficient ERC20 balance");
        emit ERC20Withdraw(token, amount);
        erc20.transfer(msg.sender, amount);
    }
    function withdrawERC721(address token, uint256 tokenId) external {
        require(msg.sender == owner, "Not Owner");
        IERC721 erc721 = IERC721(token);
        emit ERC721Withdraw(token, tokenId);
        erc721.safeTransferFrom(address(this), msg.sender, tokenId);
    }
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    function getERC20Balance(address token) external view returns (uint256) {
        IERC20 erc20 = IERC20(token);
        return erc20.balanceOf(address(this));
    }
}