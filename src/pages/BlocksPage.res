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

module Blocks = {
  @react.component
  let make = (~chainId, ~chainHeight) => {
    let blocks = HyperSyncHooks.useBlocks(~chainId, ~chainHeight)

    <table className="text-white">
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
  let chainHeight = HyperSyncHooks.useChainHeight(~chainId)
  <div>
    {"Blocks"->React.string}
    {switch chainHeight {
    | Data(chainHeight) => <Blocks chainId chainHeight />
    | Loading => "loading..."->React.string
    | Err(_exn) => "Error"->React.string
    }}
  </div>
}
