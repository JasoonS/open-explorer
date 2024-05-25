type addressType = Contract | Address

type contractStatus =
  | Verified(array<Sourcify.FilesByAddress.fileItem>)
  | NotVerified(string)
  | NotFound(string)
  | Pending

@react.component
let make = (~chainId: int, ~address: Viem.Address.t) => {
  let addressStr = address->Viem.Address.toString
  // State to hold the verified contract data
  let (contracts, setContracts) = React.useState(() => Pending)

  // Effect to load verified contract data from Sourcify API
  React.useEffect2(() => {
    let fetchVerifiedContracts = async () => {
      Js.log("looking for verifications")
      let result = await Sourcify.FilesByAddress.getFiles(chainId->Int.toString, addressStr)

      switch result {
      | {error: Some(error)} => setContracts(_ => NotVerified(error))
      | {files: Some(files)} => setContracts(_ => Verified(files))
      }
      Js.log2("VERIFICATION", result)
    }
    fetchVerifiedContracts()->ignore
    None
  }, (address, chainId))

  // Render the verified contract data
  <div className="p-4 h-full max-w-3xl max-h-screen-70 overflow-auto">
    <h2 className="text-lg font-bold my-4"> {React.string("Verified Contracts")} </h2>
    {switch contracts {
    | Pending => <p> {React.string("Loading...")} </p>
    | Verified(contractList) =>
      <div className="space-y-4">
        {contractList
        ->Array.map(file =>
          <div key=file.path className="border p-2 my-2 max-h-48 overflow-auto">
            <div className="flex justify-between items-center">
              <h3 className="font-semibold"> {file.name->React.string} </h3>
              <CopyButton textToCopy=file.content />
            </div>
            <pre className="bg-gray-100 p-2 overflow-auto max-h-32">
              {file.content->React.string}
            </pre>
          </div>
        )
        ->React.array}
      </div>
    | NotVerified(error) => <p> {React.string("Not Verified: " ++ error)} </p>
    | NotFound(message) => <p> {React.string("Not Found: " ++ message)} </p>
    }}
  </div>
}
