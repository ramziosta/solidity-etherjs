const ethers = require('ethers');
const fs = require('fs');
require('dotenv').config();

async function main() {
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY);
    const encryptedJsonKey = await wallet.encrypt(
         process.env.PRIVATE_KEY_PASSWORD,
        // new ether this parameter is the progress call back
    );
console.log(encryptedJsonKey);
fs.writeFileSync('./encryptedKey.json', encryptedJsonKey);
}
main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });

{/*
progress callback example:

    wallet.encrypt(process.env.PRIVATE_KEY, (progress) => {
        console.log(`Encryption progress: ${progress * 100}%`);
    }).then((encryptedJson) => {
        console.log('Encrypted Wallet:', encryptedJson);
    });
    */}