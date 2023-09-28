// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract AccessControl {

    event GrantRole(bytes32 indexed  role,address indexed account);
    event RevokeRole(bytes32 indexed  role,address indexed account);

    error OnlyRole(bytes32 _role);
	
    // 권한 부여 여부 check
    mapping(bytes32 => mapping(address => bool)) public roles;

    // role
    bytes32 public constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 public constant USER = keccak256(abi.encodePacked("USER"));

	
    modifier onlyRole(bytes32 _role) {
        if(!roles[_role][msg.sender]) {
            revert OnlyRole(_role);
        }
        _;
    }
	
    // contract owner에 ADMIN 권한 부여
    constructor() {
        _grantRole(ADMIN, msg.sender);
    }


    function grantRole(bytes32 _role, address _account) external onlyRole(ADMIN)  {
        _grantRole(_role,_account);
    }

    function _grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit GrantRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN)  {
        _revokeRole(_role,_account);
    }
    
    function _revokeRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = false;
        emit RevokeRole(_role, _account);
    }

}