pragma solidity ^0.4.18;

contract ERC20 {
	function totalSupply() public view returns (uint256 total_Supply);
	function balanceOf(address _owner) public view returns (uint256 balance);
	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
	function approve(address _spender, uint256 _amount) public returns (bool ok);
	function transferFrom(address _from, address _to, uint256 _amount) public returns (bool ok);
	function transfer(address _to, uint _amount)public returns (bool ok);
	event Transfer(address indexed _from, address indexed _to, uint256 _amount);
	event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
	event OwnershipTransferred(address indexed _from, address indexed _to);
}