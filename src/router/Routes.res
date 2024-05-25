type chainId = int
type blockNumber = int
type address = string
type txHash = string

type addressSubPage = Transactions | Erc20Transactions | NftTransactions | Contract
type txSubPage = Overview | Events
type page =
  | ChainSelect
  | Search({chainId: int})
  | BlocksPage({chainId: int})
  | Block({chainId: int, blockNumber: int})
  | Address({chainId: int, address: Viem.Address.t, addressSubPage: addressSubPage})
  | TransactionPage({chainId: int, txHash: string})
  | Unknown
  | Error(string)

let pageToUrlString = (pageInfo: page): string => {
  switch pageInfo {
  | Address({chainId, address, addressSubPage}) =>
    let base = `/${chainId->Int.toString}/address/${address->Viem.Address.toString}`
    let hash = switch addressSubPage {
    | Transactions => ""
    | Erc20Transactions => "#tokentxns"
    | NftTransactions => "#nfttransfers"
    | Contract => "#code"
    }
    base ++ hash
  | _placeholder => "/placeholder"
  }
}

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
      | list{"tx", transactionHash} => TransactionPage({chainId, txHash: transactionHash})
      | list{"address", address} =>
        let subView = switch url.hash {
        | "code" => Contract
        | "tokentxns" => Erc20Transactions
        | "nfttransfers" => NftTransactions
        | "" => Transactions
        | _ =>
          Js.log2("unknown url hash", url.hash)
          Transactions
        }
        switch Viem.Address.fromString(address) {
        | Ok(address) => Address({chainId, address, addressSubPage: subView})
        | Error(_) => Error("The address is invalid")
        }
      | list{} => BlocksPage({chainId: chainId})
      | _ => Unknown
      }
    | None => Error("The chainId is invalid, it must be an integer")
    }
  }
}
