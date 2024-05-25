type chainId = int
type blockNumber = int
type address = string
type txHash = string

type addressSubPage = Transactions | Erc20Transactions | Contract
type txSubPage = Overview | Events
type page =
  | ChainSelect
  | Search(chainId)
  | Block(chainId, blockNumber)
  | Address(chainId, address, addressSubPage)
  | Transaction(chainId, txHash, txSubPage)
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
      | list{"search"} => Search(chainId)

      | list{"address", address} => Address(chainId, address, Transactions)
      | _ => Unknown
      }
    | None => Error("The chainId is invalid, it must be an integer")
    }
  }
}
