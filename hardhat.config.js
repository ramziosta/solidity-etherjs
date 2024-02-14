require("@nomiclabs/hardhat-waffle");

module.exports = {
    solidity: {
        version: "0.8.19",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    },
    networks: {
        hardhat: {
            // Configuration specific to the Hardhat network
        },
        ropsten: {

        }
        // You can add other networks here
    },
    paths: {
        sources: "./contracts",
        tests: "./test",
        cache: "./cache",
        artifacts: "./artifacts"
    },
    // This is a sample. You might want to add other plugins you use.
    // You can add them by using `require` at the top and then configuring them here.
};
