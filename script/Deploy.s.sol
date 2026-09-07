// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console2} from "forge-std/Script.sol";
import {MockToken} from "../src/MockToken.sol";
import {QaiFactory} from "../src/QaiFactory.sol";
import {QaiRouter} from "../src/QaiRouter.sol";

/// @notice One-shot Base Sepolia desk: dummy USDCq + NVDAq, factory, router, seed LP.
contract Deploy is Script {
    address constant WETH = 0x4200000000000000000000000000000000000006;
    address constant TREASURY = 0x85557C90027354eAeFFe9Ee4B4f4014818d8D3e1;

    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(pk);

        uint256 usdcqLiquidity = 50_000 * 1e6;
        uint256 nvdaqLiquidity = 250 * 1e18;
        uint256 extraMint = 10;

        vm.startBroadcast(pk);

        MockToken usdcq = new MockToken("Quick AI USDCq", "USDCq", 6, usdcqLiquidity * extraMint);
        MockToken nvdaq = new MockToken("Quick AI NVDAq", "NVDAq", 18, nvdaqLiquidity * extraMint);

        QaiFactory factory = new QaiFactory(TREASURY);
        QaiRouter router = new QaiRouter(address(factory), WETH);

        usdcq.approve(address(router), type(uint256).max);
        nvdaq.approve(address(router), type(uint256).max);

        (uint256 amountA, uint256 amountB, uint256 liquidity) = router.addLiquidity(
            address(usdcq),
            address(nvdaq),
            usdcqLiquidity,
            nvdaqLiquidity,
            usdcqLiquidity,
            nvdaqLiquidity,
            deployer,
            block.timestamp + 1 hours
        );

        address pair = factory.getPair(address(usdcq), address(nvdaq));

        vm.stopBroadcast();

        console2.log("deployer", deployer);
        console2.log("USDCq   ", address(usdcq));
        console2.log("NVDAq   ", address(nvdaq));
        console2.log("factory ", address(factory));
        console2.log("router  ", address(router));
        console2.log("pair    ", pair);
        console2.log("seedA   ", amountA);
        console2.log("seedB   ", amountB);
        console2.log("lp      ", liquidity);
    }
}
