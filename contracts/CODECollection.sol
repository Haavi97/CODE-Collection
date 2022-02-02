//SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CODECollection is ERC721URIStorage, ERC721Enumerable, Ownable {
    using SafeMath for uint256;

    string public baseURI;
    uint256 public startingIndex = 0;
    uint256 public basePrice = 1e18;
    uint256 public maxTokens = 1970;

    address[] private coders;

    constructor(
        string memory name,
        string memory symbol,
        string memory _initBaseURI
    ) ERC721(name, symbol) {
        setBaseURI(_initBaseURI);
    }

    /// @dev Events of the contract
    event Minted(
        uint256 tokenId,
        address beneficiary,
        string tokenUri,
        address minter
    );

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    function addCoder(address coder) public onlyOwner {
        coders.push(coder);
    }

    function deleteCoder(address coder) public returns (bool) {
        for (uint256 i = 0; i < coders.length; i++) {
            if (coders[i] == coder) {
                coders[i] = coders[coders.length - 1];
                coders.pop();
                return true;
            }
        }
        return false;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        uint256 share = balance.div(coders.length);
        for (uint256 i = 0; i < coders.length; i++) {
            payable(coders[i]).transfer(share);
        }
    }

    function mintCodes(uint256 _count) public onlyOwner {
        uint256 supply = totalSupply();
        for (uint256 i = 0; i < _count; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    function calculatePrice() public view returns (uint256) {
        uint256 price;
        price = totalSupply() * basePrice;
        return price;
    }

    function mint(address _to, string calldata _tokenUri) public payable {
        require(calculatePrice() <= msg.value, "Value sent less than needed");

        uint256 index = totalSupply();
        _safeMint(_to, index);
        _setTokenURI(index, _tokenUri);
        emit Minted(index, _to, _tokenUri, _msgSender());
    }

    function setTokenURI(uint256 _tokenId, string memory _tokenURI)
        public
        onlyOwner
    {
        require(bytes(super.tokenURI(_tokenId)).length == 0, "URI already set");
        _setTokenURI(_tokenId, _tokenURI);
    }
}
