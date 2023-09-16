// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./libraries/Base64.sol";
import "hardhat/console.sol";

contract Web3Mint is ERC721 {
    
    struct NftAttributes {
        string name;
        string imageURL;
    }

    NftAttributes[] Web3Nfts;

    // OpenZeppelinがtokenIdsを簡単に追跡するためのライブラリを呼び出す
    using Counters for Counters.Counter;
    
    // _tokenIdsを初期化（_tokenIds=0）
    Counters.Counter private _tokenIds;

    // NFTトークンの名前とシンボルを渡す
    constructor() ERC721 ("RockNFT", "ROCK") {
        console.log("This is my NFT contract!");
    }

    // ユーザがNFTを取得するために実行する関数
    function mintIpfsNFT(string memory name, string memory imageURI) public {
        // 現在のtokenIdを取得する
        uint256 newItemId = _tokenIds.current();
        // NFTを送信者にMintする
        _safeMint(msg.sender, newItemId);
        
        Web3Nfts.push(NftAttributes({
            name: name,
            imageURL: imageURI
        }));
        // NFTがいつ・誰に作成されたかを確認する
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        // 次のNFTがMintされるときに使用するカウンターをインクリメント
        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId) public override view returns(string memory) {
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        Web3Nfts[_tokenId].name,
                        ' -- NFT #: ',
                        Strings.toString(_tokenId),
                        '", "description": "A Rock NFT", "image": "ipfs://',
                        Web3Nfts[_tokenId].imageURL,'"}'
                    )
                )
            )
        );
    

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }
}