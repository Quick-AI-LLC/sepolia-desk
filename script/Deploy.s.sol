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

        vm.startBroadcast(pk);

        MockToken usdcq = new MockToken("Quick AI USDCq", "USDCq", 6, 500_000 * 1e6);
        MockToken nvdaq = new MockToken("Quick AI NVDAq", "NVDAq", 18, 2_500 * 1e18);

        QaiFactory factory = new QaiFactory(TREASURY);
        QaiRouter router = new QaiRouter(address(factory), WETH);

        usdcq.approve(address(router), type(uint256).max);
        nvdaq.approve(address(router), type(uint256).max);

        // Seed 50,000 USDCq + 250 NVDAq. Constructor minted 10x extra inventory.
        router.addLiquidity(
            address(usdcq),
            address(nvdaq),
            50_000 * 1e6,
            250 * 1e18,
            50_000 * 1e6,
            250 * 1e18,
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
    }
}
