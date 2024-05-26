module Blocks = {
  type blockData = {
    number: int,
    hash: string,
    parentHash: string,
    // nonce: option<int>, //breaking
    // logsBloom: string,
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
          // LogsBloom,
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
                // logsBloom,
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
                // logsBloom,
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
}

module Transaction = {
  /*
Transaction Hash:
0x8a1b3dbe6301650442bfa765d4de23775fc9a4ec4329ebb5995ec7f1e3777dc4 
Status:
Pending
Block:
(Pending)
Time Last Seen:
00 days 15 hr 54 min 10 secs ago (May-25-2024 05:30:45 AM)
Time First Seen:
15 hrs ago (May-25-2024 12:38:42 AM)
Estimated Confirmation Duration:
 It appears that this txn is taking longer than usual (Learn more about Canceling/Replacing Txns  or view our  Gas Tracker)
Sponsored:
From:
0x763c396673F9c391DCe3361A9A71C8E161388000
To:
0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5 (beaverbuild)
Value:
69 wei
(< $0.000001)
Max Txn Cost/Fee:
0.0001230996 ETH
($0.46)
Gas Price:
1.69 Gwei (0.00000000169 ETH)
*/
  type transaction = {
    blockHash: string,
    blockNumber: bigint,
    from: option<Viem.Address.t>,
    gas: bigint,
    gasPrice: option<bigint>,
    hash: string,
    input: string,
    nonce: bigint,
    to: option<Viem.Address.t>,
    transactionIndex: bigint,
    value: bigint,
    v: option<string>,
    r: option<string>,
    s: option<string>,
    maxPriorityFeePerGas: option<bigint>,
    maxFeePerGas: option<bigint>,
  }

  let txSchema = S.object(s => {
    blockHash: s.field("blockHash", S.string),
    blockNumber: s.field("blockNumber", BigIntHelpers.schema),
    from: s.field("from", S.option(Viem.Address.schema)),
    gas: s.field("gas", BigIntHelpers.schema),
    gasPrice: s.field("gasPrice", S.option(BigIntHelpers.schema)),
    hash: s.field("hash", S.string),
    input: s.field("input", S.string),
    nonce: s.field("nonce", BigIntHelpers.schema),
    to: s.field("to", S.option(Viem.Address.schema)),
    transactionIndex: s.field("transactionIndex", BigIntHelpers.schema),
    value: s.field("value", BigIntHelpers.schema),
    v: s.field("v", S.option(S.string)),
    r: s.field("r", S.option(S.string)),
    s: s.field("s", S.option(S.string)),
    maxPriorityFeePerGas: s.field("maxPriorityFeePerGas", S.option(BigIntHelpers.schema)),
    maxFeePerGas: s.field("maxFeePerGas", S.option(BigIntHelpers.schema)),
  })

  type txRpcRes = {
    id: int,
    jsonrpc: string,
    result: transaction,
  }

  let txRpcResSchema = S.object(s => {
    id: s.field("id", S.int),
    jsonrpc: s.field("jsonrpc", S.string),
    result: s.field("result", txSchema),
  })

  let rpcBodySchema = S.object(s =>
    {
      "method": s.field("method", S.string),
      "params": s.field("params", S.array(S.string)),
      "id": s.field("id", S.int),
      "jsonrpc": s.field("jsonrpc", S.string),
    }
  )

  let getTransaction = async (~chainId, ~txHash, ~rpcUrl: option<string>) => {
    let hyperSyncUrl = `https://${chainId->Int.toString}.rpc.hypersync.xyz`

    let selectedRpcUrl = switch rpcUrl {
    | Some(url) => url != "" ? url : hyperSyncUrl
    | None => hyperSyncUrl
    }

    let body = {
      "method": "eth_getTransactionByHash",
      "params": [txHash],
      "id": 1,
      "jsonrpc": "2.0",
    }

    switch await QueryHelpers.executeFetchRequest(
      ~endpoint=selectedRpcUrl,
      ~method=#POST,
      ~bodyAndSchema=(body, rpcBodySchema),
      ~responseSchema=txRpcResSchema,
    ) {
    | Ok(v) => Ok(v.result)
    | Error(exn) => Error(exn)
    }
  }
}
