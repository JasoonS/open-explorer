type transaction = {
  hash: string,
  from: string,
  to: string,
  value: string, // This should be a BigInt and decimals should be a separete field.
  timestamp: string,
}

type transactionRequest = Loading | Data(Queries.Transaction.transaction) | Error(string)

module TransactionDetailsH = {
  @react.component
  let make = (~chainId: int, ~txHash) => {
    let (transactionInfo, setTransactionInfo) = React.useState(() => Loading)

    React.useEffect2(() => {
      Queries.Transaction.getTransaction(~chainId, ~txHash)
      ->Promise.then(transactionInfo => {
        Console.log(transactionInfo)
        switch transactionInfo {
        | Ok(transaction) => setTransactionInfo(_ => Data(transaction))
        | Error(err) => setTransactionInfo(_ => Error("Error fetching transaction"))
        }
        Promise.resolve()
      })
      ->Promise.catch(exn => {
        Console.error(exn)
        setTransactionInfo(_ => Error("Error fetching transaction"))
        Promise.resolve()
      })
      ->ignore
      None
    }, (chainId, txHash))

    switch transactionInfo {
    | Loading => <Loader.Pepe />
    | Error(err) => <div> {React.string(err)} </div>
    | Data(transactionInfo) =>
      <div>
        <p> {React.string("Transaction details")} </p>
        <p>
          {"blockHash: "->React.string}
          {transactionInfo.blockHash->React.string}
        </p>
        <p>
          {"blockNumber: "->React.string}
          {transactionInfo.blockNumber->BigInt.toString->React.string}
        </p>
        <p>
          {"from: "->React.string}
          {transactionInfo.from
          ->Option.getOr(Viem.Address.zeroAddress)
          ->Viem.Address.toString
          ->React.string}
        </p>
        <p>
          {"gas: "->React.string}
          {transactionInfo.gas->BigInt.toString->React.string}
        </p>
        <p>
          {"gasPrice: "->React.string}
          {transactionInfo.gasPrice->Option.getOr(0n)->BigInt.toString->React.string}
        </p>
        <p>
          {"hash: "->React.string}
          {transactionInfo.hash->React.string}
        </p>
        <p>
          {"input: "->React.string}
          {transactionInfo.input->React.string}
        </p>
        <p>
          {"maxFeePerGas: "->React.string}
          {transactionInfo.maxFeePerGas->Option.getOr(0n)->BigInt.toString->React.string}
        </p>
        <p>
          {"maxPriorityFeePerGas: "->React.string}
          {transactionInfo.maxPriorityFeePerGas->Option.getOr(0n)->BigInt.toString->React.string}
        </p>
        <p>
          {"nonce: "->React.string}
          {transactionInfo.nonce->BigInt.toString->React.string}
        </p>
        <p>
          {"r: "->React.string}
          {transactionInfo.r->Option.getOr("")->React.string}
        </p>
        <p>
          {"s: "->React.string}
          {transactionInfo.s->Option.getOr("")->React.string}
        </p>
        <p>
          {"to: "->React.string}
          {transactionInfo.to
          ->Option.getOr(Viem.Address.zeroAddress)
          ->Viem.Address.toString
          ->React.string}
        </p>
        <p>
          {"transactionIndex: "->React.string}
          {transactionInfo.transactionIndex->BigInt.toString->React.string}
        </p>
        <p>
          {"v: "->React.string}
          {transactionInfo.v->Option.getOr("")->React.string}
        </p>
        <p>
          {"value: "->React.string}
          {transactionInfo.value->Viem.Utilities.Units.formatEther->Int.toString->React.string}
        </p>
      </div>
    }
  }
}

module Overview = {
  @react.component
  let make = (~chainId, ~txHash) => {
    <div
      className="flex flex-col items-center justify-center m-0 p-0 text-primary overflow-y-hidden">
      <div className="mb-4">
        <div className="mb-4 p-4 bg-gray-100 rounded-md">
          <h1 className="text-xl font-bold"> {React.string("Transaction Overview")} </h1>
          <p>
            <strong> {React.string("Chain id:")} </strong>
            {chainId->React.string}
          </p>
          <p>
            <strong> {React.string("Address:")} </strong>
            {txHash->React.string}
            <CopyButton textToCopy={txHash} />
          </p>
        </div>
      </div>
    </div>
  }
}

@react.component
let make = (~chainId, ~txHash: string) => {
  <div
    className="flex flex-col items-center justify-center h-screen m-0 p-0 text-primary overflow-y-hidden">
    <div className="mb-4">
      <Overview chainId txHash />
      <TransactionDetailsH chainId={chainId->Int.fromString->Option.getOr(1)} txHash />
    </div>
  </div>
}
