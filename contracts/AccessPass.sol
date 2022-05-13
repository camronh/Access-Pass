//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/*

    AccessPass.sol
    --------------
    A contract that allows user to mint NFT Access Passes
    to be used in other contracts. Users can set the 
    "requester" address to grant their contract access.

*/

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract AccessPass is ERC721Enumerable {
    mapping(uint256 => address) public requesters;

    constructor() ERC721("Access Pass", "AP") {}

    function buyAccess(address _requesterAddress) public payable {
        require(msg.value >= .001 ether); // Price of access
        require(balanceOf(msg.sender) == 0, "One per users");
        uint256 tokenId = totalSupply() + 1;
        _safeMint(msg.sender, tokenId);
        requesters[tokenId] = _requesterAddress;
    }

    function setRequester(address _requesterAddress, uint256 _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "Access Denied"); // Only owner can set requester
        requesters[_tokenId] = _requesterAddress;
    }

    // Returns the requester address of the owner
    // Will fail when NFT is transfered to a new owner
    function getOwnerRequester(address _owner) public view returns (address) {
        require(balanceOf(_owner) > 0, "You do not own an Access Pass");
        uint256 tokenId = tokenOfOwnerByIndex(_owner, 0);
        return requesters[tokenId];
    }
}
