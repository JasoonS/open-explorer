type blockData = {
  blockNumber: int,
  blockTimestamp: int,
  txCount: int,
}

module Block = {
  @react.component
  let make = (~blockData) => {
    let {blockNumber, blockTimestamp, txCount} = blockData
    <div className="flex">
      <div className="flex flex-col">
        <HyperLink href="#"> {blockNumber->React.int} </HyperLink>
        <div>
          <span> {"timestamp: "->React.string} </span>
          {blockTimestamp->React.int}
        </div>
      </div>
      <div> {txCount->React.int} </div>
    </div>
  }
}

@react.component
let make = () => {
  let blocks = [{blockNumber: 1, blockTimestamp: 2, txCount: 3}]
  <div>
    {"Blocks"->React.string}
    <div> {blocks->Array.map(blockData => <Block blockData />)->React.array} </div>
  </div>
}
