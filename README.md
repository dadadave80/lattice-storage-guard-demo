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

Requires Foundry v1.8.5 / solc 0.8.36. The workflow pins the Lattice storage-safety Action by full commit SHA
(release tag `storage-layout-v1.0.0`) and every other action by SHA. It takes the trusted layout from the
event: a pull request is compared with its base, a push to `main` with the previous head of `main`.

The baseline is `storage-layout.baseline`, written by the Action's checker:

```sh
path/to/lattice/.github/actions/storage-layout/check-storage-layout.sh \
  --root . --probe script/StorageProbe.sol:StorageProbe --baseline storage-layout.baseline --update
```

The fixture is intentionally immutable: its constructor installs the counter and loupe facets.
The guard protects the declared module layout; it does not certify governance, arbitrary assembly
access, or undeclared storage. See the [Action README](https://github.com/dadadave80/lattice/blob/storage-layout-v1.0.0/.github/actions/storage-layout/README.md)
for its full scope.

## Proof runs (Action `storage-layout-v1.0.0`)

| Run | Commit | Result |
|---|---|---|
| Seed: no trusted baseline yet, so the Action fails closed | [`48d2772`](https://github.com/dadadave80/lattice-storage-guard-demo/commit/48d277237b5c4bcd7660a004ba42b259c9601e9c) | [red](https://github.com/dadadave80/lattice-storage-guard-demo/actions/runs/37923382947) |
| Seed: drift-only check (manual run) | [`48d2772`](https://github.com/dadadave80/lattice-storage-guard-demo/commit/48d277237b5c4bcd7660a004ba42b259c9601e9c) | [green](https://github.com/dadadave80/lattice-storage-guard-demo/actions/runs/37923456260) |
| [#1](https://github.com/dadadave80/lattice-storage-guard-demo/pull/1): reorder `VaultStorage` and regenerate the baseline | [`20eebf4`](https://github.com/dadadave80/lattice-storage-guard-demo/commit/20eebf4) | [red](https://github.com/dadadave80/lattice-storage-guard-demo/actions/runs/37923527240): "VaultStorage: existing members changed" |
| [#1](https://github.com/dadadave80/lattice-storage-guard-demo/pull/1): restore the compatible order | [`ed5fb74`](https://github.com/dadadave80/lattice-storage-guard-demo/commit/ed5fb74) | [green](https://github.com/dadadave80/lattice-storage-guard-demo/actions/runs/37923624481) |
| [#2](https://github.com/dadadave80/lattice-storage-guard-demo/pull/2): append `uint256 fee` and update the baseline | [`c721463`](https://github.com/dadadave80/lattice-storage-guard-demo/commit/c721463) | [green](https://github.com/dadadave80/lattice-storage-guard-demo/actions/runs/37923536837): "append-only relative to 48d2772" |

## Earlier runs

The `proof/layout-reorder` and `proof/safe-append` branches and their runs used an earlier, superseded draft
of the Action (commit `ea9ab78`, JSON manifest and baseline). They are kept for history and are not the
milestone evidence.
