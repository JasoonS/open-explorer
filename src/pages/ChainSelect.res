type dataSource = Rpc | HyperSync | EthArchive | Firehose

@react.component
let make = () => {
  // Define the supported chains
  let supportedChains: Js.Dict.t<int> = {
    "Amoy": 80002,
    "Arbitrum": 42161,
    "Arbitrum Nova": 42170,
    "Arbitrum Sepolia": 421614,
    "Aurora": 1313161554,
    "Avalanche": 43114,
    "Base": 8453,
    "Base Sepolia": 84532,
    "Berachain Artio": 80085,
    "Blast": 81457,
    "Blast Sepolia": 168587773,
    "Boba": 288,
    "BSC": 56,
    "C1 Milkomeda": 2001,
    "Canto": 25,
    "Celo": 42220,
    "Crab": 44,
    "Cronos": 25,
    "Cyber": 7560,
    "Darwinia": 46,
    "Degen": 666666666,
    "ETH": 1,
    "Fantom": 250,
    "Fhenix Testnet": 42069,
    "Flare": 14,
    "Gnosis": 100,
    "Gnosis Chiado": 10200,
    "Goerli": 5,
    "Harmony Shard 0": 1666600000,
    "Harmony Shard 1": 1666600001,
    "Hedera": 295,
    "Holesky": 17000,
    "Immutable zkEVM": 13371,
    "Inco Testnet": 9090,
    "Kava": 2222,
    "Klaytn": 8217,
    "Kroma": 255,
    "Linea": 59144,
    "Lukso": 42,
    "Manta": 169,
    "Mantle": 5000,
    "Metis": 1088,
    "Moonbeam": 1284,
    "Mumbai": 80001,
    "Neon EVM": 245022934,
    "OKBC Testnet": 195,
    "OpBNB": 204,
    "Optimism": 10,
    "Optimism Sepolia": 11155420,
    "Polygon": 137,
    "Polygon zkEVM": 1101,
    "Publicgoods": 424,
    "RSK": 30,
    "Scroll": 534352,
    "Sepolia": 11155111,
    "Shimmer EVM": 148,
    "Taiko Jolnr": 1088,
    "X Layer": 196,
    "Zeta": 7000,
    "Zircuit Testnet": 48899,
    "zkSync": 324,
    "Zora": 7777777,
  }->Obj.magic()

  let (selectedChain, setSelectedChain) = React.useState(() => "")
  let (rpcUrl, setRpcUrl) = React.useState(() => "")

  <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-4">
    <h1 className="text-2xl font-bold mb-4">
      {"Select a Blockchain and connection method"->React.string}
    </h1>
    <div className="mb-4 w-full max-w-md">
      <label className="block text-sm font-medium text-gray-700">
        {"Enter RPC URL"->React.string}
      </label>
      <input
        className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
        type_="text"
        value=rpcUrl
        onChange={e => setRpcUrl(JsxEventU.Form.target(e)["value"])}
        placeholder="Enter custom RPC URL"
      />
    </div>
    // <div className="mb-4 w-full max-w-md">
    //   <label className="block text-sm font-medium text-gray-700">
    //     {"Select a supported chain from HyperSync"->React.string}
    //   </label>
    //   // <select
    //   //   className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
    //   //   // value=selectedChain
    //   //   onChange={e => {
    //   //     ReactEvent.Form.preventDefault(e)
    //   //     // let result = ReactEvent.Form.target(e)
    //   //     // Js.log(result)
    //   //     // setSelectedChain(_ => result->Obj.magic)
    //   //   }}>
    //   //   <option value=""> {"Select a chain"->React.string} </option>
    //   //   // {supportedChains
    //   //   // ->Js.Dict.keys
    //   //   // ->Array.map(name => <option key={name} value={name}> {React.string(name)} </option>)
    //   //   // ->React.array}
    //   // </select>
    // </div>
    <div className="flex flex-col sm:flex-row sm:space-x-4 w-full max-w-md">
      <button
        className="flex-1 px-4 py-2 mb-2 sm:mb-0 bg-blue-500 text-white font-medium rounded-md shadow-sm hover:bg-blue-600 focus:outline-none"
        onClick={_ => Js.log("Selected RPC URL: " ++ rpcUrl)}>
        {"Use RPC URL"->React.string}
      </button>
      <button
        className="flex-1 px-4 py-2 mb-2 sm:mb-0 bg-blue-500 text-white font-medium rounded-md shadow-sm hover:bg-blue-600 focus:outline-none"
        onClick={_ => Js.log("Selected HyperSync Chain: " ++ selectedChain)}>
        {"Use HyperSync"->React.string}
      </button>
      <button
        className="flex-1 px-4 py-2 mb-2 sm:mb-0 bg-green-500 text-white font-medium rounded-md shadow-sm hover:bg-green-600 focus:outline-none"
        onClick={_ => Js.log("Unimplemented: Firehose")}>
        {"Use Firehose"->React.string}
      </button>
      <button
        className="flex-1 px-4 py-2 bg-purple-500 text-white font-medium rounded-md shadow-sm hover:bg-purple-600 focus:outline-none"
        onClick={_ => Js.log("Unimplemented: Subquid")}>
        {"Use Subquid"->React.string}
      </button>
    </div>
  </div>
}
