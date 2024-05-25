module QueryTypes = {
  type blockFieldOptions =
    | @as("number") Number
    | @as("hash") Hash
    | @as("parent_hash") ParentHash
    | @as("nonce") Nonce
    | @as("sha3_uncles") Sha3Uncles
    | @as("logs_bloom") LogsBloom
    | @as("transactions_root") TransactionsRoot
    | @as("state_root") StateRoot
    | @as("receipts_root") ReceiptsRoot
    | @as("miner") Miner
    | @as("difficulty") Difficulty
    | @as("total_difficulty") TotalDifficulty
    | @as("extra_data") ExtraData
    | @as("size") Size
    | @as("gas_limit") GasLimit
    | @as("gas_used") GasUsed
    | @as("timestamp") Timestamp
    | @as("uncles") Uncles
    | @as("base_fee_per_gas") BaseFeePerGas

  let blockFieldOptionsSchema = S.union([
    S.literal(Number),
    S.literal(Hash),
    S.literal(ParentHash),
    S.literal(Nonce),
    S.literal(Sha3Uncles),
    S.literal(LogsBloom),
    S.literal(TransactionsRoot),
    S.literal(StateRoot),
    S.literal(ReceiptsRoot),
    S.literal(Miner),
    S.literal(Difficulty),
    S.literal(TotalDifficulty),
    S.literal(ExtraData),
    S.literal(Size),
    S.literal(GasLimit),
    S.literal(GasUsed),
    S.literal(Timestamp),
    S.literal(Uncles),
    S.literal(BaseFeePerGas),
  ])

  type blockFieldSelection = array<blockFieldOptions>

  let blockFieldSelectionSchema = S.array(blockFieldOptionsSchema)

  type transactionFieldOptions =
    | @as("block_hash") BlockHash
    | @as("block_number") BlockNumber
    | @as("from") From
    | @as("gas") Gas
    | @as("gas_price") GasPrice
    | @as("hash") Hash
    | @as("input") Input
    | @as("nonce") Nonce
    | @as("to") To
    | @as("transaction_index") TransactionIndex
    | @as("value") Value
    | @as("v") V
    | @as("r") R
    | @as("s") S
    | @as("max_priority_fee_per_gas") MaxPriorityFeePerGas
    | @as("max_fee_per_gas") MaxFeePerGas
    | @as("chain_id") ChainId
    | @as("cumulative_gas_used") CumulativeGasUsed
    | @as("effective_gas_price") EffectiveGasPrice
    | @as("gas_used") GasUsed
    | @as("contract_address") ContractAddress
    | @as("logs_bloom") LogsBloom
    | @as("type") Type
    | @as("root") Root
    | @as("status") Status
    | @as("sighash") Sighash

  let transactionFieldOptionsSchema = S.union([
    S.literal(BlockHash),
    S.literal(BlockNumber),
    S.literal(From),
    S.literal(Gas),
    S.literal(GasPrice),
    S.literal(Hash),
    S.literal(Input),
    S.literal(Nonce),
    S.literal(To),
    S.literal(TransactionIndex),
    S.literal(Value),
    S.literal(V),
    S.literal(R),
    S.literal(S),
    S.literal(MaxPriorityFeePerGas),
    S.literal(MaxFeePerGas),
    S.literal(ChainId),
    S.literal(CumulativeGasUsed),
    S.literal(EffectiveGasPrice),
    S.literal(GasUsed),
    S.literal(ContractAddress),
    S.literal(LogsBloom),
    S.literal(Type),
    S.literal(Root),
    S.literal(Status),
    S.literal(Sighash),
  ])

  type transactionFieldSelection = array<transactionFieldOptions>

  let transactionFieldSelectionSchema = S.array(transactionFieldOptionsSchema)

  type logFieldOptions =
    | @as("removed") Removed
    | @as("log_index") LogIndex
    | @as("transaction_index") TransactionIndex
    | @as("transaction_hash") TransactionHash
    | @as("block_hash") BlockHash
    | @as("block_number") BlockNumber
    | @as("address") Address
    | @as("data") Data
    | @as("topic0") Topic0
    | @as("topic1") Topic1
    | @as("topic2") Topic2
    | @as("topic3") Topic3

  let logFieldOptionsSchema = S.union([
    S.literal(Removed),
    S.literal(LogIndex),
    S.literal(TransactionIndex),
    S.literal(TransactionHash),
    S.literal(BlockHash),
    S.literal(BlockNumber),
    S.literal(Address),
    S.literal(Data),
    S.literal(Topic0),
    S.literal(Topic1),
    S.literal(Topic2),
    S.literal(Topic3),
  ])

  type logFieldSelection = array<logFieldOptions>

  let logFieldSelectionSchema = S.array(logFieldOptionsSchema)

  type fieldSelection = {
    block?: blockFieldSelection,
    transaction?: transactionFieldSelection,
    log?: logFieldSelection,
  }

  let fieldSelectionSchema = S.object(s => {
    block: ?s.field("block", S.option(blockFieldSelectionSchema)),
    transaction: ?s.field("transaction", S.option(transactionFieldSelectionSchema)),
    log: ?s.field("log", S.option(logFieldSelectionSchema)),
  })

  type logParams = {
    address?: array<Viem.Address.t>,
    topics: array<array<Viem.Topic.t>>,
  }

  let logParamsSchema = S.object(s => {
    address: ?s.field("address", S.option(S.array(Viem.Address.schema))),
    topics: s.field("topics", S.array(S.array(Viem.Topic.schema))),
  })

  type transactionParams = {
    from?: array<Viem.Address.t>,
    to?: array<Viem.Address.t>,
    sighash?: array<string>,
  }

  let transactionParamsSchema = S.object(s => {
    from: ?s.field("from", S.option(S.array(Viem.Address.schema))),
    to: ?s.field("to", S.option(S.array(Viem.Address.schema))),
    sighash: ?s.field("sighash", S.option(S.array(S.string))),
  })

  type postQueryBody = {
    fromBlock: int,
    toBlockExclusive?: int,
    logs?: array<logParams>,
    transactions?: array<transactionParams>,
    fieldSelection: fieldSelection,
    maxNumLogs?: int,
    includeAllBlocks?: bool,
  }

  let postQueryBodySchema = S.object(s => {
    fromBlock: s.field("from_block", S.int),
    toBlockExclusive: ?s.field("to_block", S.option(S.int)),
    logs: ?s.field("logs", S.option(S.array(logParamsSchema))),
    transactions: ?s.field("transactions", S.option(S.array(transactionParamsSchema))),
    fieldSelection: s.field("field_selection", fieldSelectionSchema),
    maxNumLogs: ?s.field("max_num_logs", S.option(S.int)),
    includeAllBlocks: ?s.field("include_all_blocks", S.option(S.bool)),
  })
}

module ResponseTypes = {
  type blockData = {
    number?: int,
    hash?: string,
    parentHash?: string,
    nonce?: option<int>,
    sha3Uncles?: string,
    logsBloom?: string,
    transactionsRoot?: string,
    stateRoot?: string,
    receiptsRoot?: string,
    miner?: Viem.Address.t,
    difficulty?: option<bigint>,
    totalDifficulty?: option<bigint>,
    extraData?: string,
    size?: bigint,
    gasLimit?: bigint,
    gasUsed?: bigint,
    timestamp?: bigint,
    uncles?: option<string>,
    baseFeePerGas?: option<bigint>,
  }

  let blockDataSchema = S.object(s => {
    number: ?s.field("number", S.option(S.int)),
    hash: ?s.field("hash", S.option(S.string)),
    parentHash: ?s.field("parent_hash", S.option(S.string)),
    nonce: ?s.field("nonce", S.option(S.null(S.int))),
    sha3Uncles: ?s.field("sha3_uncles", S.option(S.string)),
    logsBloom: ?s.field("logs_bloom", S.option(S.string)),
    transactionsRoot: ?s.field("transactions_root", S.option(S.string)),
    stateRoot: ?s.field("state_root", S.option(S.string)),
    receiptsRoot: ?s.field("receipts_root", S.option(S.string)),
    miner: ?s.field("miner", S.option(Viem.Address.schema)),
    difficulty: ?s.field("difficulty", S.option(S.null(BigIntHelpers.schema))),
    totalDifficulty: ?s.field("total_difficulty", S.option(S.null(BigIntHelpers.schema))),
    extraData: ?s.field("extra_data", S.option(S.string)),
    size: ?s.field("size", S.option(BigIntHelpers.schema)),
    gasLimit: ?s.field("gas_limit", S.option(BigIntHelpers.schema)),
    gasUsed: ?s.field("gas_used", S.option(BigIntHelpers.schema)),
    timestamp: ?s.field("timestamp", S.option(BigIntHelpers.schema)),
    uncles: ?s.field("unclus", S.option(S.null(S.string))),
    baseFeePerGas: ?s.field("base_fee_per_gas", S.option(S.null(BigIntHelpers.schema))),
  })

  type transactionData = {
    blockHash?: string,
    blockNumber?: int,
    from?: option<Viem.Address.t>,
    gas?: bigint,
    gasPrice?: option<bigint>,
    hash?: string,
    input?: string,
    nonce?: int,
    to?: option<Viem.Address.t>,
    transactionIndex?: int,
    value?: bigint,
    v?: option<string>,
    r?: option<string>,
    s?: option<string>,
    maxPriorityFeePerGas?: option<bigint>,
    maxFeePerGas?: option<bigint>,
    chainId?: option<int>,
    cumulativeGasUsed?: bigint,
    effectiveGasPrice?: bigint,
    gasUsed?: bigint,
    contractAddress?: option<Viem.Address.t>,
    logsBoom?: string,
    type_?: option<int>,
    root?: option<string>,
    status?: option<int>,
    sighash?: option<string>,
  }

  let transactionDataSchema = S.object(s => {
    blockHash: ?s.field("block_hash", S.option(S.string)),
    blockNumber: ?s.field("block_number", S.option(S.int)),
    from: ?s.field("from", S.option(S.null(Viem.Address.schema))),
    gas: ?s.field("gas", S.option(BigIntHelpers.schema)),
    gasPrice: ?s.field("gas_price", S.option(S.null(BigIntHelpers.schema))),
    hash: ?s.field("hash", S.option(S.string)),
    input: ?s.field("input", S.option(S.string)),
    nonce: ?s.field("nonce", S.option(S.int)),
    to: ?s.field("to", S.option(S.null(Viem.Address.schema))),
    transactionIndex: ?s.field("transaction_index", S.option(S.int)),
    value: ?s.field("value", S.option(BigIntHelpers.schema)),
    v: ?s.field("v", S.option(S.null(S.string))),
    r: ?s.field("r", S.option(S.null(S.string))),
    s: ?s.field("s", S.option(S.null(S.string))),
    maxPriorityFeePerGas: ?s.field(
      "max_priority_fee_per_gas",
      S.option(S.null(BigIntHelpers.schema)),
    ),
    maxFeePerGas: ?s.field("max_fee_per_gas", S.option(S.null(BigIntHelpers.schema))),
    chainId: ?s.field("chain_id", S.option(S.null(S.int))),
    cumulativeGasUsed: ?s.field("cumulative_gas_used", S.option(BigIntHelpers.schema)),
    effectiveGasPrice: ?s.field("effective_gas_price", S.option(BigIntHelpers.schema)),
    gasUsed: ?s.field("gas_used", S.option(BigIntHelpers.schema)),
    contractAddress: ?s.field("contract_address", S.option(S.null(Viem.Address.schema))),
    logsBoom: ?s.field("logs_bloom", S.option(S.string)),
    type_: ?s.field("type", S.option(S.null(S.int))),
    root: ?s.field("root", S.option(S.null(S.string))),
    status: ?s.field("status", S.option(S.null(S.int))),
    sighash: ?s.field("sighash", S.option(S.null(S.string))),
  })

  type logData = {
    removed?: option<bool>,
    index?: int,
    transactionIndex?: int,
    transactionHash?: string,
    blockHash?: string,
    blockNumber?: int,
    address?: Viem.Address.t,
    data?: string,
    topic0?: option<Viem.Topic.t>,
    topic1?: option<Viem.Topic.t>,
    topic2?: option<Viem.Topic.t>,
    topic3?: option<Viem.Topic.t>,
  }

  let logDataSchema = S.object(s => {
    removed: ?s.field("removed", S.option(S.null(S.bool))),
    index: ?s.field("log_index", S.option(S.int)),
    transactionIndex: ?s.field("transaction_index", S.option(S.int)),
    transactionHash: ?s.field("transaction_hash", S.option(S.string)),
    blockHash: ?s.field("block_hash", S.option(S.string)),
    blockNumber: ?s.field("block_number", S.option(S.int)),
    address: ?s.field("address", S.option(Viem.Address.schema)),
    data: ?s.field("data", S.option(S.string)),
    topic0: ?s.field("topic0", S.option(S.null(Viem.Topic.schema))),
    topic1: ?s.field("topic1", S.option(S.null(Viem.Topic.schema))),
    topic2: ?s.field("topic2", S.option(S.null(Viem.Topic.schema))),
    topic3: ?s.field("topic3", S.option(S.null(Viem.Topic.schema))),
  })

  type data = {
    blocks?: array<blockData>,
    transactions?: array<transactionData>,
    logs?: array<logData>,
  }

  let dataSchema = S.object(s => {
    blocks: ?s.field("blocks", S.array(blockDataSchema)->S.option),
    transactions: ?s.field("transactions", S.array(transactionDataSchema)->S.option),
    logs: ?s.field("logs", S.array(logDataSchema)->S.option),
  })

  type queryResponse = {
    data: array<data>,
    archiveHeight: int,
    nextBlock: int,
    totalTime: int,
  }

  let queryResponseSchema = S.object(s => {
    data: s.field("data", S.array(dataSchema)),
    archiveHeight: s.field("archive_height", S.int),
    nextBlock: s.field("next_block", S.int),
    totalTime: s.field("total_execution_time", S.int),
  })
}

let executeHyperSyncQuery = (~serverUrl, ~postQueryBody: QueryTypes.postQueryBody): promise<
  result<ResponseTypes.queryResponse, exn>,
> => {
  QueryHelpers.executeFetchRequest(
    ~endpoint=serverUrl ++ "/query",
    ~method=#POST,
    ~bodyAndSchema=(postQueryBody, QueryTypes.postQueryBodySchema),
    ~responseSchema=ResponseTypes.queryResponseSchema,
  )
}

let getArchiveHeight = {
  let responseSchema = S.object(s => s.field("height", S.int))

  async (~serverUrl): result<int, exn> => {
    await QueryHelpers.executeFetchRequest(
      ~endpoint=serverUrl ++ "/height",
      ~method=#GET,
      ~responseSchema,
    )
  }
}
