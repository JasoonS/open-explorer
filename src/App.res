@@warning("-27")
@react.component
let make = () => {
  let page = Routes.usePage()

  switch page {
  | ChainSelect => <ChainSelect />
  | Search({chainId}) => <p> {"search"->React.string} </p>
  | BlocksPage({chainId}) => <BlocksPage chainId />
  | BlockPage({chainId, blockNumber}) => <BlockPage chainId blockNumber/>
  | Address({chainId, address, addressSubPage}) => <Address chainId address addressSubPage />
  | TransactionPage({chainId, txHash}) => <TransactionPage chainId={chainId->Int.toString} txHash />
  | Unknown => <p> {"unknown"->React.string} </p>
  | Error(error) => <p> {error->React.string} </p>
  }
}
