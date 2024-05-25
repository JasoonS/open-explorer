module Block = {
  @react.component
  let make = (~blockData: Queries.blockData) => {
    let {number: blockNumber, timestamp: blockTimestamp, transactionCount} = blockData
    <div className="flex">
      <div className="flex flex-col">
        <HyperLink href="#"> {blockNumber->React.int} </HyperLink>
        <div>
          <span> {"timestamp: "->React.string} </span>
          {blockTimestamp->BigInt.toString->React.string}
        </div>
      </div>
      <div> {transactionCount->React.int} </div>
    </div>
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

    <div>
      {switch blocks {
      | Data(blocks) =>
        blocks->Array.map(blockData => <Block key=blockData.hash blockData />)->React.array
      | Loading => "loading..."->React.string
      | Err(_exn) => "Error"->React.string
      }}
    </div>
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
