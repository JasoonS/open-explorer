@send external toStringUnsafe: 'a => string = "toString"
module BlockDetails = {
  @react.component
  let make = (~blockData: Queries.Blocks.blockData) => {
    <div>
      {blockData
      ->Obj.magic
      ->Js.Dict.entries
      ->Array.map(((key, val)) => {
        <p key className="text-wrap"> {`${key}: ${val->toStringUnsafe}`->React.string} </p>
      })
      ->React.array}
    </div>
  }
}

module Overview = {
  @react.component
  let make = (~chainId, ~blockNumber, ~blockHash) => {
    <div
      className="flex flex-col items-center justify-center m-0 p-0 text-primary overflow-y-hidden">
      <div className="mb-4">
        <div className="mb-4 p-4 bg-gray-100 rounded-md">
          <h1 className="text-xl font-bold"> {React.string("Block Overview")} </h1>
          <p>
            <strong> {React.string("Chain id: ")} </strong>
            {chainId->Int.toString->React.string}
          </p>
          <p>
            <strong> {React.string("Block Number: ")} </strong>
            {blockNumber->Int.toString->React.string}
          </p>
          <p>
            <strong> {React.string("Block Hash: ")} </strong>
            {blockHash->React.string}
            <CopyButton textToCopy={blockHash} />
          </p>
        </div>
      </div>
    </div>
  }
}

@react.component
let make = (~chainId, ~blockNumber: int) => {
  let block = HyperSyncHooks.useBlock(~chainId, ~blockNumber)
  switch block {
  | Data(Some(blockData)) =>
    <div
      className="flex flex-col items-center justify-center h-screen m-0 p-0 text-primary overflow-y-hidden">
      <div className="mb-4">
        <Overview chainId blockNumber=blockData.number blockHash=blockData.hash />
        <BlockDetails blockData />
      </div>
    </div>
  | Data(None) => `Block ${blockNumber->Int.toString} does not exist.`->React.string
  | Err(_) => `Error loading block ${blockNumber->Int.toString}`->React.string
  | Loading => <Loader.Pepe />
  }
}
