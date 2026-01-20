## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

1. Unit: test a specific part of our code
2. Integration: test how our code is working with other parts of our code
3. Forked: test our code on a similated real environment
4. Staging: test our code on a real environemnt that is not prod

https://docs.soliditylang.org/en/latest/style-guide.html
## Usage

### Install

check this https://github.com/smartcontractkit/chainlink-brownie-contracts
```shell
$ forge install smartcontractkit/chainlink-brownie-contracts
```
to use them need not add remupping. File foundry.toml, add this
remappings = [
    '@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/',
]


### Build

```shell
$ forge build
```

### Test
for fork test check: https://alchemy.com/
```shell
$ forge test
$ forge test -vvv --fork-url $SEPOLIA_RPC_URL
$ forge test -vvv --fork-url $MAINNET_RPC_URL

check the gas used
$ forge snapshot
view the low-level storage layout
$ forge inspect FundMe storageLayout
by checking the storage you can check any public&private variable
$ cast storage YOUR_CONTRACT_ADDRESS
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
