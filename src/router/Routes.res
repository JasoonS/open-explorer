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
