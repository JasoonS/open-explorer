@@warning("-27")
@react.component
let make = () => {
  let page = Routes.usePage()

  switch page {
  | ChainSelect => <ChainSelect />
  | Search({chainId}) => <p> {"search"->React.string} </p>
  | BlocksPage({chainId}) => <BlocksPage chainId />
  | Block({chainId, blockNumber}) => <p> {"block"->React.string} </p>
  | Address({chainId, address, addressSubPage}) => <Address chainId address addressSubPage />
  | Transaction({chainId, txHash, txSubPage}) => <p> {"tx"->React.string} </p>
  | Unknown => <p> {"unknown"->React.string} </p>
  | Error(error) => <p> {error->React.string} </p>
  }
}
