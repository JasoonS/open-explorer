type blockData = {
  number: int,
  hash: string,
  parentHash: string,
  // nonce: option<int>, //breaking
  logsBloom: string,
  transactionsRoot: string,
  stateRoot: string,
  receiptsRoot: string,
  miner: Viem.Address.t,
  difficulty: option<bigint>,
  totalDifficulty: option<bigint>,
  extraData: string,
  size: bigint,
  gasLimit: bigint,
  gasUsed: bigint,
  timestamp: bigint,
  // baseFeePerGas: option<bigint>,
  // transactionCount: int,
}

let getBlocks = async (~serverUrl, ~fromBlock, ~toBlock) => {
  let postQueryBody: HyperSyncJsonApi.QueryTypes.postQueryBody = {
    fromBlock,
    toBlockExclusive: toBlock + 1,
    transactions: [{}],
    fieldSelection: {
      block: [
        Number,
        Hash,
        ParentHash,
        // Nonce, //breaking
        // Sha3Uncles,
        LogsBloom,
        TransactionsRoot,
        StateRoot,
        ReceiptsRoot,
        Miner,
        Difficulty,
        TotalDifficulty,
        ExtraData,
        Size,
        GasLimit,
        GasUsed,
        Timestamp,
        // Uncles,
        // BaseFeePerGas, //Not working
      ],
      transaction: [Hash],
    },
    includeAllBlocks: true,
  }

  switch await HyperSyncJsonApi.executeHyperSyncQuery(~serverUrl, ~postQueryBody) {
  | Ok(res) =>
    res.data->Array.flatMap(res => {
      switch res {
      | {blocks, _} =>
        blocks->Array.map(block => {
          switch block {
          | {
              number,
              hash,
              parentHash,
              logsBloom,
              transactionsRoot,
              stateRoot,
              receiptsRoot,
              miner,
              difficulty,
              totalDifficulty,
              extraData,
              size,
              gasLimit,
              gasUsed,
              timestamp,
              // baseFeePerGas, //not working
            } => {
              number,
              hash,
              parentHash,
              logsBloom,
              transactionsRoot,
              stateRoot,
              receiptsRoot,
              miner,
              difficulty,
              totalDifficulty,
              extraData,
              size,
              gasLimit,
              gasUsed,
              timestamp,
              // baseFeePerGas, //not working
              // transactionCount: transactions->Array.length,
            }
          | block =>
            Js.log(
              block
              ->Obj.magic
              ->Js.Dict.entries
              ->Belt.Array.keepMap(((k, v)) => v->Option.isSome ? Some(k) : None),
            )
            Js.Exn.raiseError("Missing fields in block response")
          }
        })
      | _res => Js.Exn.raiseError("'blocks' or 'transactions' was not found in response")
      }
    })
  | Error(err) =>
    Console.log2("Query failure:", err)
    Js.Exn.raiseError("Failed blocks query")
  }
}
