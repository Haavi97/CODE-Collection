require('dotenv').config();
require('hardhat-deploy');
require('ethers');
require('@nomiclabs/hardhat-ethers');
require('hardhat-deploy-ethers');

const accounts = {
    mnemonic: process.env.MNEMONIC || "test test test test test test test test test test test junk",
}

module.exports = {
    solidity: {
        version: '0.8.6',
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
    gasReporter: {
        currency: 'USD',
        enabled: false,
        gasPrice: 50,
    },
    networks: {
        mainnet: {
            url: `https://rpc.polis.tech`,
            accounts,
            chainId: 333999,
            live: true,
            saveDeployments: true,
            tags: ["staging"],
            gasPrice: 5000000000,
            gasMultiplier: 2,
            timeout: 100000
        },
        sparta: {
            url: `https://sparta-rpc.polis.tech`,
            accounts,
            chainId: 333888,
            live: true,
            saveDeployments: true,
            tags: ["staging"],
            gasPrice: 20000000000,
            gasMultiplier: 8,
            timeout: 100000
        },
        mumbai: {
            url: "https://rpc-mumbai.maticvigil.com/",
            accounts,
            chainId: 80001,
            live: true,
            saveDeployments: true,
            tags: ["staging"],
            gasMultiplier: 2,
        },
        coverage: {
            url: 'http://localhost:8555',
        },

        localhost: {
            url: `http://127.0.0.1:8545`
        },
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
        dev: {
            default: 1,
        },
    }
};