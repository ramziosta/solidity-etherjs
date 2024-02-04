const {ethers} = require('ethers');
const fs = require("fs");

require('dotenv').config();

async function DeployV2() {
    const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
    const encryptedJson = fs.readFileSync("./encryptedKey.json", "utf8");
    let wallet = await ethers.Wallet.fromEncryptedJson(
        encryptedJson,
        process.env.PRIVATE_KEY_PASSWORD
    );

    wallet = await wallet.connect(provider);
    const abi = JSON.parse(fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8"));
    const bin = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.bin", "utf8");
    const contractFactory = new ethers.ContractFactory(abi, bin, wallet);
    const contract = await contractFactory.deploy({gasLimit: 6721975, gasPrice: ethers.parseUnits('100', 'gwei')});
    await contract.deploymentTransaction().wait(1);
    const currentFavoriteNumber = await contract.retrieve();  // doesnt read retrieve() it is found in the ABI?
    const transactionResponse = await contract.store(7); // does not read the store function in SimpleStorage.sol
    const updatedFavoriteNumber = await contract.retrieve();


}

DeployV2().then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exitCode = 1;
    });

{/*
PRIVATE_KEY_PASSWORD=mpassword deplyV2.js
is ran in the CLI and we can remove it from the .env file
this code makes sure the security as we have encrypted the private key and pass the private key password in the cli



*/}