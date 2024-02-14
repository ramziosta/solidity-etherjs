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
    console.log("🚀 Deploying, please wait...")
    console.log("💄" + contractFactory)
    const contract = await contractFactory.deploy({gasLimit: 6721975, gasPrice: ethers.parseUnits('160', 'gwei')});
    console.log("💰" + contract);
    await contract.deploymentTransaction().wait(1);
    const currentFavoriteNumber = await contract.getFunction("retrieve").staticCall();
    console.log(" 🧠 Current favorite number is: ", currentFavoriteNumber.toString());
    const transactionResponse = await contract.getFunction("store").send("7");
    const receipt = await transactionResponse.wait(1)
    console.log("✅" + receipt);
    const updatedFavoriteNumber = await contract.getFunction("retrieve").staticCall();
    console.log( "🐤" + updatedFavoriteNumber.toString());
    console.log("👹 Updated favorite number is: ", updatedFavoriteNumber.toString())



}

DeployV2().then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exitCode = 1;
    });

{/*
PRIVATE_KEY_PASSWORD=password deplyV2.js
is run in the CLI and we can remove it from the .env file
this code makes sure the security as we have encrypted the private key and pass the private key password in the cli



*/}