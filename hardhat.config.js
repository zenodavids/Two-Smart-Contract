require('@nomicfoundation/hardhat-toolbox')
require('dotenv').config({ path: '.env' })

// const QUICKNODE_HTTP_URL = process.env.QUICKNODE_HTTP_URL
// const PRIVATE_KEY = process.env.PRIVATE_KEY

const { QUICKNODE_HTTP_URL, PRIVATE_KEY } = process.env

module.exports = {
  solidity: '0.8.4',
  // networks for deploying the smart contract
  networks: {
    // polygon testnet
    mumbai: {
      url: QUICKNODE_HTTP_URL,
      accounts: [PRIVATE_KEY],
    },
  },
}
