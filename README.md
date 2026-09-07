# Quick AI Sepolia Desk

Public Base Sepolia Uniswap V2-style builder desk. Paste two ERC-20s, fund the pair, swap, read reserves. ERC-20 LP only. No farms, no staking, no launchpad, no V3 NFT.

Host target: `sepolia.quickai.build`

This exists so a builder or an agent with a normal wallet can create and test a pair without minting a Uniswap V3 position NFT. The desk is a standing venue, not a one-shot demo.

Advertising surface for [inferproof.one](https://inferproof.one) (IP1) and Quick AI x402 services.

## How the UI works

Token A, Token B, and optional pair are contract address fields. Swap and Fund LP use those addresses. First `addLiquidity` on this router creates the pair if `factory.getPair` is zero.

The seeded USDCq / NVDAq pair is a prefilled worked example, not the only pair the desk will talk to.

## What the one-shot script deploys

1. `USDCq` mock (6 decimals). Placeholder for mainnet USDC.
2. `NVDAq` mock (18 decimals). Placeholder for mainnet B20 / NVDA-style inventory.
3. `QaiFactory` with `feeToSetter` = treasury `0x85557C90027354eAeFFe9Ee4B4f4014818d8D3e1`
4. `QaiRouter` pointed at the factory and Base Sepolia WETH `0x4200000000000000000000000000000000000006`
5. Seed LP: 50,000 USDCq + 250 NVDAq to the deployer

The deployer also receives extra inventory (10x the seed) so the Mandate film can swap without hunting a faucet for dummy tokens.

Live 84532 addresses: `deployments/84532.json`.

## Broadcast from a laptop / PC

Need Foundry, Base Sepolia ETH on the deployer, and the deployer key.

```bash
git clone https://github.com/Quick-AI-LLC/sepolia-desk
cd sepolia-desk
forge install
export PRIVATE_KEY=0xYOUR_KEY
forge script script/Deploy.s.sol:Deploy --rpc-url https://sepolia.base.org --broadcast -vv
```

Copy the five logged addresses into `web/index.html` `CFG`. Hermes hosts `web/` at `sepolia.quickai.build`.

On camera: These are Sepolia placeholders. USDCq stands in for USDC. NVDAq stands in for B20. Same two clicks on mainnet.
