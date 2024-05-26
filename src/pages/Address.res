type transaction = {
  hash: string,
  from: string,
  to: string,
  value: string, // This should be a BigInt and decimals should be a separete field.
  timestamp: string,
}

let coerceReactElUnsafe: 'a => React.element = v => Obj.magic(v)
module TransactionRow = {
  @react.component
  let make = (~tx: Queries.Transaction.transaction, ~rowStyle: string, ~symbol, ~chainId) => {
    <tr className=rowStyle>
      <td className="py-1 px-3 text-left">
        <HyperLink.Page page={TransactionPage({chainId, txHash: tx.hash})}>
          {tx.hash->React.string}
        </HyperLink.Page>
      </td>
      <td className="py-1 px-3 text-left"> {tx.from->coerceReactElUnsafe} </td>
      <td className="py-1 px-3 text-left"> {tx.to->coerceReactElUnsafe} </td>
      /// TODO: rather do a base 18 big int conversion here.
      <td className="py-1 px-3 text-left">
        {(tx.value->BigInt.toString ++ symbol)->React.string}
      </td>
    </tr>
  }
}

module Transactions = {
  @react.component
  let make = (~chainId, ~isContract, ~address, ~symbolForAll: option<string>=?) => {
    let txs = HyperSyncHooks.useAddressTransactions(
      ~address,
      ~chainId,
      ~direction={isContract ? To : From},
    )
    switch txs {
    | Data(txs) =>
      let transactions = txs->Array.slice(~start=0, ~end=20)
      <dev>
        <p className="text-xs">
          {"For a summary of activity this address try the "->React.string}
          <HyperLink href="https://chaindensity.xyz"> {"ChainDensity"->React.string} </HyperLink>
          {" tool."->React.string}
        </p>
        <table
          className="text-white border rounded border-2 border-primary p-2 m-2 bg-black bg-opacity-30">
          <thead className="m-10 uppercase bg-black">
            <tr>
              <th className="py-3 px-6 text-left"> {"Hash"->React.string} </th>
              <th className="py-3 px-6 text-left"> {"From"->React.string} </th>
              <th className="py-3 px-6 text-left"> {"To"->React.string} </th>
              <th className="py-3 px-6 text-left"> {"Value"->React.string} </th>
            </tr>
          </thead>
          <tbody>
            {transactions
            ->Array.mapWithIndex((tx, index) =>
              <TransactionRow
                key=tx.hash
                symbol={symbolForAll->Option.getOr("")}
                tx
                chainId
                rowStyle={index->Int.mod(2) == 0 ? "bg-white bg-opacity-10" : ""}
              />
            )
            ->React.array}
          </tbody>
        </table>
      </dev>
    | Loading => <Loader.Pepe />
    | Err(_) => React.string(`Error loading transactions of ${address->Viem.Address.toString}`)
    }
  }
}

let getBalance = async (client, address) => {
  let balance = await client->Viem.Client.getBalance({"address": address})
  let formattedBalance = balance->Viem.Utilities.Units.formatEther
  formattedBalance
}

let makeClientFromChainId = chainId => {
  let viemChain = chainId->Viem.Chains.fromChainId
  let validChain = switch viemChain {
  | None => Js.Exn.raiseError("Unable to map chainId to viem chain")
  | Some(viemChain) => viemChain
  }
  Viem.Client.createPublicClient({
    "chain": validChain,
    "transport": Viem.Transport.http(),
  })
}

module Overview = {
  @react.component
  let make = (~address: Viem.Address.t, ~client: Viem.Client.t) => {
    let url = RescriptReactRouter.useUrl()
    let (balance, setBalance) = React.useState(() => "")
    let (ensAddress, setEnsAddress) = React.useState(() => None)

    React.useEffect0(() => {
      client
      ->getBalance(address)
      ->Promise.thenResolve(bal => setBalance(_ => bal->Int.toString))
      ->ignore

      None
    })

    React.useEffect0(() => {
      let _ =
        address
        ->Viem.Address.toString
        ->ENSDataCustomFetch.tryResolveEnsHandleFromAddress
        ->Promise.then(ensAddress => {
          setEnsAddress(_ => Some(ensAddress))
          None->Promise.resolve
        })
      None
    })

    <div className="mb-4 p-4 bg-gray-100 rounded-md">
      <h1 className="text-xl font-bold"> {React.string("Address Overview")} </h1>
      <p>
        <strong> {React.string("Address:")} </strong>
        {address->Viem.Address.toString->React.string}
        <CopyButton textToCopy={address->Viem.Address.toString} />
      </p>
      {switch ensAddress {
      | Some(ensAddress) =>
        <p>
          <strong> {React.string("ENS:")} </strong>
          {ensAddress->React.string}
        </p>
      | None => React.null
      }}
      <p>
        <strong> {React.string("Balance:")} </strong>
        {balance->React.string}
        {" "->React.string}
        {"native token"->React.string}
      </p>
    </div>
  }
}

module InfoTabs = {
  @react.component
  let make = (
    ~chainId,
    ~address: Viem.Address.t,
    ~addressSubPage: Routes.addressSubPage,
    ~client: Viem.Client.t,
  ) => {
    let (isContract, setIsContract) = React.useState(() => true) // Default to true just to be safe.

    React.useEffect0(() => {
      let checkIsContract = async () => {
        let size = await client->Viem.getContractSize(address)
        setIsContract(_ => size > 0)
      }
      checkIsContract()->ignore

      None
    })

    let erc20Transfers: array<Queries.Transaction.transaction> = [
      {
        hash: "0x3",
        from: "0xdef",
        to: "0xghi",
        value: "1000",
        timestamp: "2024-05-23 10:20:30",
      },
    ]->Obj.magic

    let pushSubPage = (newSubPage: Routes.addressSubPage) => {
      let url = Address({chainId, address, addressSubPage: newSubPage})->Routes.pageToUrlString

      url->RescriptReactRouter.push
    }

    <>
      <div className="flex space-x-4 border-b">
        <button
          className={`py-2 px-4 ${addressSubPage === Transactions
              ? "border-b-2 border-blue-500"
              : ""}`}
          onClick={_ => pushSubPage(Transactions)}>
          {React.string("Transactions")}
        </button>
        {isContract
          ? <button
              className={`py-2 px-4 ${addressSubPage === Routes.Contract
                  ? "border-b-2 border-blue-500"
                  : ""}`}
              onClick={_ => pushSubPage(Contract)}>
              {React.string("Contract")}
            </button>
          : React.null}
        <button
          className={`py-2 px-4 ${addressSubPage === Erc20Transactions
              ? "border-b-2 border-blue-500"
              : ""}`}
          onClick={_ => pushSubPage(Erc20Transactions)}>
          {React.string("ERC20 Transfers")}
        </button>
      </div>
      {switch addressSubPage {
      | Transactions => <Transactions address isContract chainId symbolForAll="ETH" />
      | Contract =>
        if isContract {
          <Contract chainId address />
        } else {
          pushSubPage(Transactions)
          React.null
        }
      | Erc20Transactions => <Transactions address isContract chainId /> //todo
      | _ => React.null
      }}
    </>
  }
}
@react.component
let make = (~chainId, ~address: Viem.Address.t, ~addressSubPage: Routes.addressSubPage) => {
  let client = makeClientFromChainId(chainId)

  <div
    className="flex flex-col items-center justify-center h-screen m-0 p-0 text-primary overflow-y-hidden">
    <div className="mb-4">
      <Overview address client />
      <InfoTabs address chainId addressSubPage client />
    </div>
    // <div className="p-4 max-w-3xl mx-auto shadow-md max-h-screen-90 box-border">
    //   // <div className="mb-4">
    //   <Overview address />
    //   <InfoTabs address chainId addressSubPage />
    //   // </div>
  </div>
}
