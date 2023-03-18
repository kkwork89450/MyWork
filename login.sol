pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Test is ERC20{
    uint private owner_pwd;
    address private _owner;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol){
        _owner = msg.sender;
    }

    modifier onlyOwner(uint _login){
        require (msg.sender == _owner, "You are not the owner!");
        require (_login == owner_pwd, "Wrong password!");
        _;
    }

    function checkOwner() public view returns (string memory){
        if (msg.sender == _owner){
            return "You are the owner.";
        }
        else {
            return "You are not the owner";
        }
    }

    function setPwd(uint _pwd) public{
        require (msg.sender == _owner, "You are not the owner!");
        owner_pwd = _pwd;
    }

    function testLogin() onlyOwner(_login) public returns (string memory){
        return "Success";
    }
}
