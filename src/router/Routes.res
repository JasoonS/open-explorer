type chainId = int
type blockNumber = int
type address = string
type txHash = string

type addressSubPage = Transactions | Erc20Transactions | Contract
type txSubPage = Overview | Events
type page =
  | ChainSelect
  | Search({chainId: int})
  | BlocksPage({chainId: int})
  | Block({chainId: int, blockNumber: int})
  | Address({chainId: int, address: string, addressSubPage: addressSubPage})
  | Transaction({chainId: int, txHash: string, txSubPage: txSubPage})
  | Unknown
  | Error(string)

let usePage = () => {
  let url = RescriptReactRouter.useUrl()

  switch url.path {
  | list{} => ChainSelect
  | list{chainIdStr, ...restOfParams} =>
    switch chainIdStr->Int.fromString {
    // TODO: check that the chainId is of a supported chain
    | Some(chainId) =>
      switch restOfParams {
      | list{"search"} => Search({chainId: chainId})

      | list{"address", address} => Address({chainId, address, addressSubPage: Transactions})
      | list{} => BlocksPage({chainId: chainId})
      | _ => Unknown
      }
    | None => Error("The chainId is invalid, it must be an integer")
    }
  }
}
