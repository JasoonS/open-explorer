module BlockRow = {
  @react.component
  let make = (~blockData: Queries.blockData) => {
    let {number: blockNumber, timestamp: blockTimestamp, transactionCount} = blockData
    <tr>
      <td>
        <HyperLink href="#block_placeholder"> {blockNumber->React.int} </HyperLink>
      </td>
      <td> {blockTimestamp->BigInt.toString->React.string} </td>
      <td>
        <HyperLink href="#transactions_placeholder"> {transactionCount->React.int} </HyperLink>
      </td>
      <td> {blockData.miner->Viem.Address.toString->React.string} </td>
      <td> {blockData.gasUsed->BigInt.toString->React.string} </td>
      <td> {blockData.gasLimit->BigInt.toString->React.string} </td>
    </tr>
  }
}

exception UnsupportedChain(int)
let getChainName = (~chainId) =>
  switch chainId {
  | 1 => "eth"
  | 137 => "polygon"
  | chainId => UnsupportedChain(chainId)->raise
  }

let getServerUrl = (~chainId) => {
  let name = getChainName(~chainId)
  `https://${name}.hypersync.xyz`
}

module Blocks = {
  @react.component
  let make = (~serverUrl, ~chainHeight) => {
    let blocks = HyperSyncHooks.useBlocks(~serverUrl, ~chainHeight)

    <table>
      <tr>
        <th> {"Block"->React.string} </th>
        <th> {"Age"->React.string} </th>
        <th> {"Txn"->React.string} </th>
        <th> {"Fee Recipient"->React.string} </th>
        <th> {"Gas Used"->React.string} </th>
        <th> {"Gas Limit"->React.string} </th>
      </tr>
      {switch blocks {
      | Data(blocks) =>
        blocks->Array.map(blockData => <BlockRow key=blockData.hash blockData />)->React.array
      | Loading => "loading..."->React.string
      | Err(_exn) => "Error"->React.string
      }}
    </table>
  }
}

@react.component
let make = (~chainId) => {
  let serverUrl = getServerUrl(~chainId)
  let chainHeight = HyperSyncHooks.useChainHeight(~serverUrl)
  <div>
    {"Blocks"->React.string}
    {switch chainHeight {
    | Data(chainHeight) => <Blocks serverUrl chainHeight />
    | Loading => "loading..."->React.string
    | Err(_exn) => "Error"->React.string
    }}
  </div>
}
