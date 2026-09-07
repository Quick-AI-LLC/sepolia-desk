# Quick AI Sepolia Desk

Base Sepolia Uniswap V2-style builder desk. Swap and ERC-20 LP only. No farms, no staking, no launchpad.

Host target: `sepolia.quickai.build`

This exists so an agent or a human with a normal wallet can fund a pair without minting a Uniswap V3 NFT.

## What the one-shot script deploys

1. `USDCq` mock (6 decimals). Placeholder for mainnet USDC.
2. `NVDAq` mock (18 decimals). Placeholder for mainnet B20 / NVDA-style inventory.
3. `QaiFactory` with `feeToSetter` = treasury `0x85557C90027354eAeFFe9Ee4B4f4014818d8D3e1`
4. `QaiRouter` pointed at the factory and Base Sepolia WETH `0x4200000000000000000000000000000000000006`
5. Seed LP: 50,000 USDCq + 250 NVDAq to the deployer

The deployer also receives extra inventory (10x the seed) so the Mandate film can swap without hunting a faucet for dummy tokens.

## Broadcast from a laptop

Need Foundry, Base Sepolia ETH on the deployer, and the deployer key.

```bash
git clone https://github.com/Quick-AI-LLC/sepolia-desk
cd sepolia-desk
forge install
export PRIVATE_KEY=0xYOUR_KEY
forge script script/Deploy.s.sol:Deploy --rpc-url https://sepolia.base.org --broadcast -vv
```

Copy the five logged addresses into `web/index.html` `CFG`. Point `sepolia.quickai.build` at `web/`.

On camera: These are Sepolia placeholders. USDCq stands in for USDC. NVDAq stands in for B20. Same two clicks on mainnet.

If broadcast slips, option 1 still works: any sourced testnet LP plus that sentence.
