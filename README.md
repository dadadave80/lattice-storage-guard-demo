# Lattice storage guard — independent consumer

A tiny Diamond project that uses the published Lattice storage-layout Action in CI, without importing
any Lattice Solidity. Its only Solidity dependency is pinned `diamond-lib`. The counter facet stores
its value in `example.storage.Vault`; the compile-only probe imports that actual source struct.
This is a test fixture, holds no funds, and is not production software.

```sh
git clone --recurse-submodules https://github.com/dadadave80/lattice-storage-guard-demo.git
cd lattice-storage-guard-demo
forge test -vv
```

Requires Foundry v1.8.1 / solc 0.8.36. The workflow pins the reusable Action and trusted seed baseline
by full commit SHA. It demonstrates a red run for a layout reorder (even with a regenerated candidate
snapshot), then green after the compatible fix, followed by a safe tail append.

The fixture is intentionally immutable: its constructor installs the counter and loupe facets.
The guard protects the declared module layout; it does not certify governance, arbitrary assembly
access, or undeclared storage. See the Action README for its full scope and baseline update commands.

Proof runs will be recorded after they complete.
