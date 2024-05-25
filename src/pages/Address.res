type transaction = {
  hash: string,
  from: string,
  to: string,
  value: string,
  timestamp: string,
}

type contract = {
  name: string,
  address: string,
}

type erc20Transfer = {
  hash: string,
  from: string,
  to: string,
  value: string,
  timestamp: string,
}

module Overview = {
  @react.component
  let make = (~address: Viem.Address.t) => {
    let balance = "12.34 ETH"
    <div className="mb-4 p-4 bg-gray-100 rounded-md">
      <h1 className="text-xl font-bold"> {React.string("Address Overview")} </h1>
      <p>
        <strong> {React.string("Address:")} </strong>
        {address->Viem.Address.toString->React.string}
      </p>
      <p>
        <strong> {React.string("Balance:")} </strong>
        {balance->React.string}
      </p>
    </div>
  }
}

module InfoTabs = {
  @react.component
  let make = (~chainId, ~address: Viem.Address.t, ~addressSubPage: Routes.addressSubPage) => {
    // Dummy data for overview and transactions
    let transactions = [
      {hash: "0x1", from: "0x123", to: "0x456", value: "1.0 ETH", timestamp: "2024-05-25 12:34:56"},
      {hash: "0x2", from: "0x789", to: "0xabc", value: "2.5 ETH", timestamp: "2024-05-24 11:22:33"},
    ]
    let contracts = [
      {name: "ContractA", address: "0xContractA"},
      {name: "ContractB", address: "0xContractB"},
    ]
    let erc20Transfers = [
      {
        hash: "0x3",
        from: "0xdef",
        to: "0xghi",
        value: "1000 USDT",
        timestamp: "2024-05-23 10:20:30",
      },
    ]

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
        <button
          className={`py-2 px-4 ${addressSubPage === Routes.Contract
              ? "border-b-2 border-blue-500"
              : ""}`}
          onClick={_ => pushSubPage(Contract)}>
          {React.string("Contracts")}
        </button>
        <button
          className={`py-2 px-4 ${addressSubPage === Erc20Transactions
              ? "border-b-2 border-blue-500"
              : ""}`}
          onClick={_ => pushSubPage(Erc20Transactions)}>
          {React.string("ERC20 Transfers")}
        </button>
      </div>
      {switch addressSubPage {
      | Transactions =>
        <div>
          <h2 className="text-lg font-bold my-4"> {React.string("Transactions")} </h2>
          {transactions
          ->Array.map(tx =>
            <div key=tx.hash className="p-4 border rounded-md mb-2">
              <p>
                <strong> {React.string("Hash:")} </strong>
                {tx.hash->React.string}
              </p>
              <p>
                <strong> {React.string("From:")} </strong>
                {tx.from->React.string}
              </p>
              <p>
                <strong> {React.string("To:")} </strong>
                {tx.to->React.string}
              </p>
              <p>
                <strong> {React.string("Value:")} </strong>
                {tx.value->React.string}
              </p>
              <p>
                <strong> {React.string("Timestamp:")} </strong>
                {tx.timestamp->React.string}
              </p>
            </div>
          )
          ->React.array}
        </div>
      | Contract =>
        <div>
          <h2 className="text-lg font-bold my-4"> {React.string("Verified Contracts")} </h2>
          {contracts
          ->Array.map(contract =>
            <div key=contract.address className="p-4 border rounded-md mb-2">
              <p>
                <strong> {React.string("Name:")} </strong>
                {contract.name->React.string}
              </p>
              <p>
                <strong> {React.string("Address:")} </strong>
                {contract.address->React.string}
              </p>
            </div>
          )
          ->React.array}
        </div>
      | Erc20Transactions =>
        <div>
          <h2 className="text-lg font-bold my-4"> {React.string("ERC20 Transfers")} </h2>
          {erc20Transfers
          ->Array.map(tx =>
            <div key=tx.hash className="p-4 border rounded-md mb-2">
              <p>
                <strong> {React.string("Hash:")} </strong>
                {tx.hash->React.string}
              </p>
              <p>
                <strong> {React.string("From:")} </strong>
                {tx.from->React.string}
              </p>
              <p>
                <strong> {React.string("To:")} </strong>
                {tx.to->React.string}
              </p>
              <p>
                <strong> {React.string("Value:")} </strong>
                {tx.value->React.string}
              </p>
              <p>
                <strong> {React.string("Timestamp:")} </strong>
                {tx.timestamp->React.string}
              </p>
            </div>
          )
          ->React.array}
        </div>
      | _ => React.null
      }}
    </>
  }
}
@react.component
let make = (~chainId, ~address: Viem.Address.t, ~addressSubPage: Routes.addressSubPage) => {
  <div className="p-4 max-w-3xl mx-auto shadow-md">
    <div className="mb-4">
      <Overview address />
      <InfoTabs address chainId addressSubPage />
    </div>
  </div>
}
