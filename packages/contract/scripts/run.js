const main = async () => {
  // コントラクトをコンパイル
  // コントラクトを扱うために必要なファイルが`artifact`直下に生成される
  const nftContractFactory = await hre.ethers.getContractFactory("Web3Mint");

  // HardhatがローカルにEthereumネットワークを作成する
  const nftContract = await nftContractFactory.deploy();

  // コントラクトMintされ、ローカルのブロックチェーンにデプロイされる
  await nftContract.deployed();
  console.log("Contract deployed to: ", nftContract.address);

  // makeAnEpicNFT関数を呼び出す
  let txn = await nftContract.mintIpfsNFT(
    "rockno1",
    "bafybeidhwsu3cvuh5vv6ldxf6np6tco4ujhrvhnfhjng6bjeitwtven4um"
  )

  // Mintingが仮想マイナーによって承認されるのを待つ
  await txn.wait();
  let returnedTokenUri = await nftContract.tokenURI(0);
  console.log("tokenURI:", returnedTokenUri);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
};

runMain();
