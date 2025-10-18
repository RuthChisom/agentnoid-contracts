## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Notes

```
This is simplified: royaltyInfo call uses ERC2981. The ModelNFT contract set token royalty receiver to the creator when minted.
Co-creator splits are paid out directly by Marketplace by reading ModelNFT.models. This pattern is okay for prototype; in production we'd pull-payments or safe-splits with on-chain escrow + ACP invocation.
Extend to ERC20 payments: add buyAndMintWithERC20 with ERC20 transferFrom and allowances.
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
forge install OpenZeppelin/openzeppelin-contracts --no-commit
```
forge script script/Deploy.s.sol:DeployScript --rpc-url "$BASE_SEPOLIA_RPC_URL"  --broadcast --private-key "$PRIVATE_KEY" --verify

```

ModelNFT deployed at: 0xdFB2Dcb29dfDBD31b78f7f2f97046Ab1DAcecDA7
ImageNFT deployed at: 0xa0658eB59f1171a7Bd06FBA2aD598952EAc79764
Marketplace deployed at: 0x6C705a4a29061F6fcDD1D2D87339c983DeC11CAa
```
