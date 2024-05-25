@react.component
let make = (~chainId: int, ~address: Viem.Address.t) => {
  let addressStr = address->Viem.Address.toString
  // State to hold the verified contract data
  let (contracts, setContracts) = React.useState(() => None)

  // Effect to load verified contract data from Sourcify API
  React.useEffect2(() => {
    let fetchContracts = async () => {
      let result = await Sourcify.CheckByAddresses.check(addressStr, chainId->Int.toString)
      setContracts(_ => Some(result))
    }

    fetchContracts()->ignore
    None
  }, (address, chainId))

  // Render the verified contract data
  <div className="p-4">
    <h2 className="text-lg font-bold my-4"> {React.string("Verified Contracts")} </h2>
    {switch contracts {
    | None => <p> {React.string("Loading...")} </p>
    | Some(contractList) =>
      Js.log(contractList)
      <table className="w-full border-collapse">
        <thead>
          <tr>
            <th className="border p-2"> {React.string("Address")} </th>
            <th className="border p-2"> {React.string("Status")} </th>
          </tr>
        </thead>
        <tbody>
          {contractList
          ->Array.map(contract =>
            <tr key=contract.address>
              <td className="border p-2"> {contract.address->React.string} </td>
              <td className="border p-2">
                {contract.status->Option.getOr("not verified or found")->React.string}
              </td>
            </tr>
          )
          ->React.array}
        </tbody>
      </table>
    }}
  </div>
}
