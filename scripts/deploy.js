const { ethers } = require('hardhat')
const fs = require('fs')

require('dotenv').config({ path: '.env' })

async function main() {
  const NigeriaDecides = await ethers.getContractFactory('NigeriaDecides')

  const nigeriaDecides = await NigeriaDecides.deploy([
    '0x696d70726f76652d64656d6f6372616379000000000000000000000000000000',
    '0x6b6565702d64656d6f6372616379000000000000000000000000000000000000',
    '0x676f6f642d6469746163746f7200000000000000000000000000000000000000',
    '0x616e617263687900000000000000000000000000000000000000000000000000',
  ])

  await nigeriaDecides.deployed()

  fs.writeFileSync(
    './utils.js',
    `
  export const OWNER_ADDRESS = "${nigeriaDecides.signer.address}"
export const CONTRACT_ADDRESS = "${nigeriaDecides.address}"
`
  )
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
