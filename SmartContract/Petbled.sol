// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./AccessControl.sol";

contract Petbled is  ERC721Enumerable, AccessControl {
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIds;

    constructor() ERC721("Petbled", "PetBloodDonorCardToken") {}

    mapping(uint =>string ) public tokenURIs ;   

    //토큰의 URI(ipfs주소)를 보여줌
    function tokenURI(uint _tokenId) override public view returns (string memory) {
        return  tokenURIs[_tokenId] ;
    }
     
 
   mapping( uint256 => bool) public tokenUSE;   //토큰 사용여부를 저장 
    //NFT 사용여부를 보여줌
    function getNfttokenUSE(uint _tokenId) public view returns (bool) {
        return  tokenUSE[_tokenId] ;
    }




    function mintNFT( string memory _tokenURI) public onlyRole(ADMIN) returns (uint256) {
        _tokenIds.increment();

        uint256 tokenId = _tokenIds.current();
        tokenURIs[tokenId] = _tokenURI;
        tokenUSE[tokenId] = false;  //nft 사용가능

        _mint(msg.sender, tokenId); //_mint함수로 민팅
   
        return tokenId;
    }



    struct NftTokenData {
        uint256 nftTokenId;
        string  nftTokenURI ;   
        bool use; //헌혈증을 사용했는지 여부      
    }

    //나의 NFT 확인(사용자 전용)
    function getNftTokens(address _nftTokenOwner) view public returns (NftTokenData[] memory) {
        uint256 balanceLength = balanceOf(_nftTokenOwner);    //토큰의 갯수 가져오기
        //require(balanceLength != 0, "Owner did not have token.");   //토큰을 하나도 안가지고 있을때

        NftTokenData[] memory nftTokenData = new NftTokenData[](balanceLength);

        //가지고 있는 토큰만큼 반복
        for(uint256 i = 0; i < balanceLength; i++) {
            uint256 nftTokenId = tokenOfOwnerByIndex(_nftTokenOwner, i);
            string memory nftTokenURI = tokenURI(nftTokenId);
            bool use = getNfttokenUSE(nftTokenId);  //nft 사용여부
            nftTokenData[i] = NftTokenData(nftTokenId , nftTokenURI, use);
        }

        return nftTokenData;

    }
//모든 NFT 확인(관리자 전용)
    function getNftTokens_admin() view public returns (NftTokenData[] memory) {
        uint256 balanceLength = totalSupply();    //토큰의 갯수 가져오기
        //require(balanceLength != 0, "Owner did not have token.");   //토큰을 하나도 안가지고 있을때

        NftTokenData[] memory nftTokenData = new NftTokenData[](balanceLength);

        //가지고 있는 토큰만큼 반복
        for(uint256 i = 0; i < balanceLength; i++) {
            uint256 nftTokenId = tokenByIndex(i);
            string memory nftTokenURI = tokenURI(nftTokenId);
            bool use = getNfttokenUSE(nftTokenId);  //nft 사용여부
            nftTokenData[i] = NftTokenData(nftTokenId , nftTokenURI, use);
        }

        return nftTokenData;

    }
     


//NFT 삭제
    function burn( uint256 _tokenId) public onlyRole(ADMIN){
        address addr_owner = ownerOf(_tokenId);
        require( addr_owner == msg.sender, "msg.sender is not the owner of the token");
        _burn(_tokenId);
    }



//NFT 사용
    function NFTuse( uint256 _tokenId)  public onlyRole(ADMIN){
        address addr_owner = ownerOf(_tokenId);
        require( addr_owner == msg.sender, "msg.sender is not the owner of the token");
        tokenUSE[_tokenId]= true;
    }

}
