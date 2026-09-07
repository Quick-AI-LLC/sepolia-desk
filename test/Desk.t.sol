// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {MockToken} from "../src/MockToken.sol";
import {QaiFactory} from "../src/QaiFactory.sol";
import {QaiRouter} from "../src/QaiRouter.sol";

contract DeskTest is Test {
    MockToken usdcq;
    MockToken nvdaq;
    QaiFactory factory;
    QaiRouter router;
    address alice = address(0xA11CE);

    function setUp() public {
        usdcq = new MockToken("USDCq", "USDCq", 6, 1_000_000 * 1e6);
        nvdaq = new MockToken("NVDAq", "NVDAq", 18, 10_000 * 1e18);
        factory = new QaiFactory(address(this));
        router = new QaiRouter(address(factory), address(0x4200000000000000000000000000000000000006));
        usdcq.approve(address(router), type(uint256).max);
        nvdaq.approve(address(router), type(uint256).max);
    }

    function testSeedAndSwap() public {
        router.addLiquidity(
            address(usdcq),
            address(nvdaq),
            50_000 * 1e6,
            250 * 1e18,
            50_000 * 1e6,
            250 * 1e18,
            address(this),
            block.timestamp + 1
        );
        address pair = factory.getPair(address(usdcq), address(nvdaq));
        assertTrue(pair != address(0));

        usdcq.transfer(alice, 100 * 1e6);
        vm.startPrank(alice);
        usdcq.approve(address(router), type(uint256).max);
        address[] memory path = new address[](2);
        path[0] = address(usdcq);
        path[1] = address(nvdaq);
        uint256[] memory amounts = router.swapExactTokensForTokens(100 * 1e6, 1, path, alice, block.timestamp + 1);
        vm.stopPrank();
        assertGt(amounts[1], 0);
        assertEq(nvdaq.balanceOf(alice), amounts[1]);
    }
}
