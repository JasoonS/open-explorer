type contractStatus =
  | Verified(array<Sourcify.FilesByAddress.fileItem>)
  | NotVerified(string)
  | NotFoundOnEtherscan(string)
  | Pending

@react.component
let make = (~chainId: int, ~address: Viem.Address.t) => {
  let addressStr = address->Viem.Address.toString
  // State to hold the verified contract data
  let (contracts, setContracts) = React.useState(() => Pending)

  let fetchVerifiedContracts = async () => {
    let result = await Sourcify.FilesByAddress.getFiles(chainId->Int.toString, addressStr)
    switch result {
    | {error, _} => setContracts(_ => NotVerified(error))
    | {files} => setContracts(_ => Verified(files))
    | _ => setContracts(_ => NotVerified("No files for verified contract found."))
    }
  }

  let verifyOnEtherscan = async () => {
    setContracts(_ => Pending)
    let body: Sourcify.VerifyEtherscan.requestBody = {
      address: addressStr,
      chainId: chainId->Int.toString,
    }
    let verifyResult = await Sourcify.VerifyEtherscan.verify(body)

    switch verifyResult {
    | {error: Some(error)} => setContracts(_ => NotFoundOnEtherscan(error))
    | _ => fetchVerifiedContracts()->ignore
    }
    // Refetch the data after verification attempt
  }

  // Effect to load verified contract data from Sourcify API
  React.useEffect2(() => {
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
    | NotVerified(error) =>
      <div>
        <p> {React.string("Not Verified: " ++ error)} </p>
        <button
          className="mt-4 bg-blue-500 text-white py-2 px-4 rounded"
          onClick={_ => verifyOnEtherscan()->ignore}>
          {React.string("Verify on Etherscan")}
        </button>
      </div>
    | NotFoundOnEtherscan(message) =>
      <div>
        <p> {React.string("Not Found on Etherscan: " ++ message)} </p>
        <p className="mt-4">
          {React.string("Please consider verifying contract on Sourcify if possible.")}
        </p>
        <a
          href="https://sourcify.dev/#/verifier"
          target="_blank"
          className="mt-2 bg-green-500 text-white py-2 px-4 rounded inline-block">
          {React.string("Verify on Sourcify")}
        </a>
      </div>
    }}
  </div>
}
