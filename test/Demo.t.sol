// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;
import {DemoDiamond, CounterFacet} from "@demo/DemoDiamond.sol";
import {IDiamondLoupe} from "@diamond/interfaces/IDiamondLoupe.sol";

contract DemoTest {
    function testCounterRoutesThroughDiamond() public {
        DemoDiamond diamond = new DemoDiamond();
        CounterFacet counter = CounterFacet(address(diamond));
        assert(counter.total() == 0);
        counter.increment();
        assert(counter.total() == 1);
        assert(IDiamondLoupe(address(diamond)).facetAddresses().length == 2);
    }
}
