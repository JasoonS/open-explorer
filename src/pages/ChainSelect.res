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
  // "Canto": 25,
  "Celo": 42220,
  "Crab": 44,
  // "Cronos": 25,
  "Cyber": 7560,
  "Darwinia": 46,
  // "Degen": 666666666,
  "ETH": 1,
  "Fantom": 250,
  "Fhenix Testnet": 42069,
  "Flare": 14,
  "Gnosis": 100,
  "Gnosis Chiado": 10200,
  "Goerli": 5,
  "Harmony Shard 0": 1666600000,
  // "Harmony Shard 1": 1666600001,
  // "Hedera": 295,
  "Holesky": 17000,
  // "Immutable zkEVM": 13371,
  // "Inco Testnet": 9090,
  // "Kava": 2222,
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
  // "OpBNB": 204,
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
  // "Zircuit Testnet": 48899,
  "zkSync": 324,
  "Zora": 7777777,
}->Obj.magic

@react.component
let make = () => {
  let (selectedDataSource, setSelectedDataSource) = React.useState(() => DataSource.HyperSync)
  let (selectedChain, setSelectedChain) = React.useState(() => "")
  let (rpcUrl, setRpcUrl) = React.useState(() => "https://eth.llamarpc.com")
  let (_, setLocalRpc) = LocalStorageHooks.useLocalRpcStorage()
  let (_, setDataSource) = LocalStorageHooks.useDataSourceStorage()

  // reset this to
  React.useEffect1(() => {
    setLocalRpc("")
    None
  }, [])

  <div
    className="flex flex-col items-center justify-center h-screen m-0 p-0 text-primary overflow-y-hidden">
    <h1 className="text-4xl font-bold my-3">
      {Time.useRotatingCharacterAnimation(~delay=160, ">?#>?ᗧ*&$⍨])⎌#]")->React.string}
      {Time.useTypedCharactersString(
        ~delay=35,
        ` / select a data source and network`,
      )->React.string}
    </h1>
    <div className="flex flex-col sm:flex-row sm:space-x-4 w-full justify-center my-4">
      <Buttons
        text="HyperSync"
        onClick={_ => {
          let strDataSource = DataSource.dataSourceToString(DataSource.HyperSync)
          setDataSource(strDataSource)
          setSelectedDataSource(_ => HyperSync)
        }}
        isActive={selectedDataSource == HyperSync}
      />
      <Buttons
        text="RPC URL"
        onClick={_ => {
          setDataSource(DataSource.dataSourceToString(DataSource.Rpc))
          setSelectedDataSource(_ => Rpc)
        }}
        isActive={selectedDataSource == Rpc}
      />
      <Buttons
        text="Firehose"
        onClick={_ => {
          setSelectedDataSource(_ => Firehose)
        }}
        isActive={selectedDataSource == Firehose}
      />
      <Buttons
        text="EthArchive"
        onClick={_ => setSelectedDataSource(_ => EthArchive)}
        isActive={selectedDataSource == EthArchive}
      />
    </div>
    {switch selectedDataSource {
    | Rpc =>
      <div className="mb-4 w-full max-w-[600px] flex items-center space-x-4">
        <input
          className="mt-1 block px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm flex-1"
          type_="text"
          value=rpcUrl
          onChange={e => {
            let rpcSet = JsxEventU.Form.target(e)["value"]
            setLocalRpc(rpcSet)
            setRpcUrl(rpcSet)
          }}
          placeholder="enter custom RPC URL"
        />
        <input
          className="mt-1 block px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm flex-1"
          type_="numeric"
          value=selectedChain
          onChange={e => setSelectedChain(JsxEventU.Form.target(e)["value"])}
          placeholder="enter ChainId"
        />
        <button
          className="ml-4 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          onClick={_ => {
            setDataSource(DataSource.dataSourceToString(DataSource.Rpc))
            setLocalRpc(rpcUrl)
            RescriptReactRouter.push(`/${selectedChain}`)
          }}>
          {"submit"->React.string}
        </button>
      </div>
    | HyperSync =>
      <div className="mb-4 w-full max-w-[600px]">
        <select
          className="mt-1 block w-full px-3 py-2 border border-primary border-1 bg-white bg-opacity-80 shadow "
          // value=selectedChain
          onChange={e => {
            ReactEvent.Form.preventDefault(e)

            let _setChainId =
              Js.Nullable.toOption(JsxEventU.Form.target(e)["value"])
              ->Option.flatMap(chainName => Js.Dict.get(supportedChains, chainName))
              ->Option.map(chainId => RescriptReactRouter.push(`/${chainId->Int.toString}`))
          }}>
          <option value=""> {"/ select a chain"->React.string} </option>
          {supportedChains
          ->Js.Dict.keys
          ->Array.map(name => <option key={name} value={name}> {React.string(name)} </option>)
          ->React.array}
        </select>
      </div>
    | EthArchive =>
      <p> {"Eth Archive is not implemented yet, we are open to contribution."->React.string} </p>
    | Firehose =>
      <p> {"Firehose is not implemented yet, we are open to contribution."->React.string} </p>
    }}
  </div>
}
