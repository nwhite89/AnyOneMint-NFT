//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AM is ERC721, Ownable {
    uint32 private currentSupply = 0;

    // Mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    constructor() ERC721("Anyone Mint", "AM") {
    }

    function totalSupply() public view returns (uint256) {
        return currentSupply;
    }

    function mintNFT(string memory _tokenURI) external {
        currentSupply++;
        uint32 tokenId = currentSupply;
        _safeMint(msg.sender, tokenId);
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI)) : "";
    }

    function updateTokenURI (uint256 tokenID, string memory _tokenURI) external {
        require(_exists(tokenID), "Token does not exist");
        require(ownerOf(tokenID) == msg.sender, "Only the token owner can set variation.");

        _tokenURIs[tokenID] = _tokenURI;
    }

    function withdraw(uint amount) external onlyOwner {
        require(payable(msg.sender).send(amount));
    }
}
