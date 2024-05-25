# Open Explorer

A light, self-sovereign first, open source block explorer

### Light

The tool runs entirely in the front end.

### Fast

The ui leverages next generation data lakes for performant queries, such as [hypersync](https://docs.envio.dev/docs/overview-hypersync), [firehose](https://github.com/streamingfast/firehose-core/tree/develop/firehose) and [eth-archive](https://github.com/subsquid/eth-archive) that would make feature rich queries otherwise impossible purely using rpc without a dedicated backend.

### Open Source

Transparent, verifiable and extensible.

### Self sovereign first

While maintaining the ease of not needing to run an entire node, the explorer allows you to switch between sources and provide your own rpc endpoints obfuscating requests and giving the end user control.

## Why

We want to be able to see whats happening on the blockchain, we want to run it ourselves locally without running a full archive node.

The most popular block explorer is closed source and expensive

[Otterscan](https://github.com/otterscan/otterscan) is awesome but requires the user to run a full node and has custom methods

Another major benefit is being able to easily run a local explorer that can connect to your local blockchain instance for ease of local blockchain insights and development.

## Built with

- [ReScript](https://rescript-lang.org)
- [Tailwind](https://tailwindcss.com/)
- [Verifier Alliance](https://verifieralliance.org)

## Get started

Run ReScript in dev mode:

```sh
pnpm run res:dev
```

In another tab, run the Vite dev server:

```sh
pnpm run dev
```

## Further work

- [ ] RPC rotation mode for maximum obfiscation
- [ ] "Contract verification" for local network blockchain development

## Reporting Issues

If you encounter any bugs or have suggestions for improvements, please open a gh issue. Provide as much detail as possible to help us understand and resolve the issue.

## Contributions

We welcome contributions and efforts to make Open Explorer better! If you have any questions or need further assistance, feel free to reach out to the maintainers.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](/LICENSE.md).

## Donations

As we don't have a purpose of the funds, if you would like to support the project, please donate through to Goerli Dezentral gGmbH, the non profit and organizers of EthBerlin 4, where Open Explorer is born.
Donations to [dezent.eth](https://etherscan.io/address/0x59cc3Fc56B8B2988F259EC1E6f3446907130f728);
