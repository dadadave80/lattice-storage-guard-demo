// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {Diamond} from "@diamond/Diamond.sol";
import {DiamondLib, DiamondStorage, FacetCut, FacetCutAction} from "@diamond/libraries/DiamondLib.sol";
import {DiamondLoupeFacet} from "@diamond/facets/DiamondLoupeFacet.sol";
import {VaultLib} from "@demo/VaultLib.sol";

/// @title CounterFacet
/// @notice Harmless counter fixture sharing the diamond's ERC-7201 storage.
contract CounterFacet {
    function increment() external {
        VaultLib.store().total++;
    }

    function total() external view returns (uint256) {
        return VaultLib.store().total;
    }
}

/// @title DemoDiamond
/// @author Modified from diamond-lib (https://github.com/dadadave80/diamond-lib)
/// @notice Minimal immutable Diamond consumer; only demonstrates namespaced facet storage.
contract DemoDiamond is Diamond {
    constructor() {
        FacetCut[] memory cuts = new FacetCut[](2);
        bytes4[] memory counter = new bytes4[](2);
        counter[0] = CounterFacet.increment.selector;
        counter[1] = CounterFacet.total.selector;
        cuts[0] = FacetCut(address(new CounterFacet()), FacetCutAction.Add, counter);
        bytes4[] memory loupe = new bytes4[](4);
        loupe[0] = 0x7a0ed627;
        loupe[1] = 0xadfca15e;
        loupe[2] = 0x52ef6b2c;
        loupe[3] = 0xcdffacc6;
        cuts[1] = FacetCut(address(new DiamondLoupeFacet()), FacetCutAction.Add, loupe);
        DiamondStorage storage ds = DiamondLib.diamondStorage();
        for (uint256 i; i < cuts.length; ++i) {
            DiamondLib.addFacet(ds, cuts[i].facetAddress);
            for (uint256 j; j < cuts[i].functionSelectors.length; ++j) {
                DiamondLib.addFunction(ds, cuts[i].functionSelectors[j], uint96(j), cuts[i].facetAddress);
            }
        }
    }
}
