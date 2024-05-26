module BlockRow = {
  @react.component
  let make = (~blockData: Queries.Blocks.blockData, ~rowStyle: string, ~chainId: int) => {
    let {number: blockNumber, timestamp: blockTimestamp} = blockData
    <tr className=rowStyle>
      <td className="py-1 px-3 text-left">
        <HyperLink href="#block_placeholder"> {blockNumber->React.int} </HyperLink>
      </td>
      <td className="py-1 px-3 text-left">
        {(blockTimestamp->BigInt.toFloat *. 1000.)
        ->Js.Date.fromFloat
        ->DateFns.formatDistanceToNowWithSeconds
        ->React.string}
      </td>
      // <td className="py-1 px-3 text-left">
      //   <HyperLink href="#transactions_placeholder"> {transactionCount->React.int} </HyperLink>
      // </td>
      <td className="py-1 px-3 text-left">
        <HyperLink.Page
          page={Routes.Address({
            chainId,
            address: blockData.miner,
            addressSubPage: Routes.Transactions,
          })}>
          {DisplayAddress.ellipsifyMiddle(
            ~inputString=blockData.miner->Viem.Address.toString,
            ~precedingTrailingCharactersLength=10,
          )->React.string}
        </HyperLink.Page>
      </td>
      <td className="py-1 px-3 text-left"> {blockData.gasUsed->BigInt.toString->React.string} </td>
      <td className="py-1 px-3 text-left"> {blockData.gasLimit->BigInt.toString->React.string} </td>
    </tr>
  }
}

module Blocks = {
  @react.component
  let make = (~chainId, ~chainHeight, ~page, ~pageSize) => {
    let (blocks, isLoading) = HyperSyncHooks.useBlocks(
      ~chainId,
      ~chainHeight,
      ~pageIndex=page,
      ~pageSize,
    )

    <div>
      {isLoading ? <Loader.Pepe /> : React.null}
      <table
        className="text-white border rounded border-2 border-primary p-2 m-2 bg-black bg-opacity-30">
        <thead className="m-10 uppercase bg-black">
          <tr>
            <th className="py-3 px-6 text-left"> {"Block"->React.string} </th>
            <th className="py-3 px-6 text-left"> {"Age"->React.string} </th>
            // <th className="py-3 px-6 text-left"> {"Txn"->React.string} </th>
            <th className="py-3 px-6 text-left"> {"Validated by"->React.string} </th>
            <th className="py-3 px-3 text-left"> {"Gas Used"->React.string} </th>
            <th className="py-3 px-3 text-left"> {"Gas Limit"->React.string} </th>
          </tr>
        </thead>
        <tbody>
          {switch blocks {
          | Data(blocks) =>
            blocks
            ->Array.mapWithIndex((blockData, index) =>
              <BlockRow
                key=blockData.hash
                blockData
                rowStyle={index->Int.mod(2) == 0 ? "bg-white bg-opacity-10" : ""}
                chainId
              />
            )
            ->React.array
          | Loading => <tr> {"loading..."->React.string} </tr>
          | Err(_exn) => <tr> {"Error"->React.string} </tr>
          }}
        </tbody>
      </table>
    </div>
  }
}

module TableOuter = {
  @react.component
  let make = (~chainId, ~chainHeight) => {
    let (page, setPage) = React.useState(() => 0)
    let pageSize = 10
    <div className="overflow-x-auto">
      <Blocks chainId chainHeight page pageSize />
      <Pagination
        activePage={page + 1}
        numPages={chainHeight / pageSize - 1}
        onChange={newPage => setPage(_ => newPage - 1)}
      />
    </div>
  }
}

@react.component
let make = (~chainId) => {
  let chainHeight = HyperSyncHooks.useChainHeight(~chainId)

  let (dataSource, _) = LocalStorageHooks.useDataSourceStorage()

  <div>
    <div
      className="flex flex-col items-center justify-center h-screen m-0 p-0 text-primary overflow-y-hidden overflow-x-hidden">
      <SearchBar />
      {switch dataSource {
      | HyperSync =>
        <>
          {switch chainHeight {
          | Data(chainHeight) => <TableOuter chainId chainHeight />
          | Loading => "loading..."->React.string
          | Err(_exn) => "Error"->React.string
          }}
        </>
      | _ => React.null
      }}
    </div>
  </div>
}
