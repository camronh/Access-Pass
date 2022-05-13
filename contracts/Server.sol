//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./AccessPass.sol";

contract Server {
    AccessPass public accessPass;
    uint256 public requestsMade = 0;

    constructor(address _accessPassAddress) {
        accessPass = AccessPass(_accessPassAddress);
    }

    function makeRequest(address _requesterAddress) public {
        // Check if msg.sender is owner of _tokenId
        require(
            accessPass.balanceOf(msg.sender) >= 1,
            "You do not own an Access Pass"
        );
        require(
            _requesterAddress == accessPass.getOwnerRequester(msg.sender),
            "Requester invalid"
        );
        requestsMade++;
    }
}
