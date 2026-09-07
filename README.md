# Quick AI Sepolia Desk

Live Base Sepolia DEX front end. Uniswap V2-style swap and ERC-20 LP. No farms. No staking. No launchpad. No V3 NFT.

**Live UI:** [sepolia.quickai.build](https://sepolia.quickai.build)

The Rails for an Agentic Economy. Standing builder desk so a human or an agent with a normal wallet can fund a pair and swap without minting a Uniswap V3 position NFT. Advertising venue for [inferproof.one](https://inferproof.one) (IP1) and Quick AI x402 services.

USDCq stands in for USDC. NVDAq stands in for B20. Same two clicks on mainnet.

## Live 84532

Source of truth: [`deployments/84532.json`](deployments/84532.json)

| | |
| --- | --- |
| Chain | Base Sepolia `84532` |
| UI | https://sepolia.quickai.build |
| Factory | `0x38a3cB65B6B1D378322229e59f5Db28d9D047fFA` |
| Router | `0xd610cF391eaDd09F09C1a83020A35d1825c25075` |
| Pair (USDCq / NVDAq) | `0x2154d212C4f86deD422fA70042A35806506EE66C` |
| USDCq (6 dec) | `0x7a396228f178f68546646495CBeF09dD668f3a69` |
| NVDAq (18 dec) | `0x9B8C15122EB281d3e0CAD6725A66A4A4A5C7660d` |
| WETH | `0x4200000000000000000000000000000000000006` |
| feeToSetter / treasury | `0x85557C90027354eAeFFe9Ee4B4f4014818d8D3e1` |

Agent path: `approve` -> `addLiquidity` -> `swapExactTokensForTokens`.

Not Uniswap V3. Not the Position Manager. First `addLiquidity` on this router creates the pair if `factory.getPair` is zero.

Paste any two ERC-20s in the UI. The seeded USDCq / NVDAq pair is a prefilled worked example, not the only pair the desk will talk to.

Explorers:

- Pair: [Blockscout](https://base-sepolia.blockscout.com/address/0x2154d212C4f86deD422fA70042A35806506EE66C) / [Basescan](https://sepolia.basescan.org/address/0x2154d212C4f86deD422fA70042A35806506EE66C)
- Sample addLiquidity: [0x6ed45b...96e3](https://base-sepolia.blockscout.com/tx/0x6ed45bfbfbf5271ca61228b386f0da64121e1d3b4130f091667ed822c88a96e3)

## What this is not

Not a token launch. Not a farm. Testnet placeholders only. AWAL / CDP validation will not price these mocks. That is expected. An x402 access rail on this desk is planned after Mandate, not in this repo yet.

## How the UI works

Token A, Token B, and optional pair are contract address fields. Swap, Fund LP, and LP metrics use those addresses. Hosted from `web/` on Ionos at `sepolia.quickai.build`. Do not point GitHub Pages at `web/` or the two hosts will drift.

## Reproduce

Need Foundry, Base Sepolia ETH, and a deployer key. This redeploys a *new* factory and mocks. It does not overwrite the live addresses above.

```bash
git clone https://github.com/Quick-AI-LLC/sepolia-desk
cd sepolia-desk
forge install foundry-rs/forge-std
forge test -vv
export PRIVATE_KEY=0xYOUR_KEY
forge script script/Deploy.s.sol:Deploy --rpc-url https://sepolia.base.org --broadcast -vv
```

The one-shot script deploys USDCq, NVDAq, factory, router, and a seed LP of 50,000 USDCq + 250 NVDAq. Extra inventory (10x seed) is minted to the deployer.

## License

- `QaiFactory`, `QaiPair`, `QaiRouter`: GPL-3.0-or-later
- `MockToken`, deploy script, tests, static UI: MIT as marked in-file

See [LICENSE](LICENSE).

## Links

- https://quickai.build
- https://inferproof.one
- https://github.com/Quick-AI-LLC
- https://linktr.ee/CDAQAI
- [@CDAQAI](https://x.com/CDAQAI)
