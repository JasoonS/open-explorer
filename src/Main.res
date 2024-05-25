%%raw("import './styles/index.css'")
%%raw("import './styles/remove-default.css'")

let createMainnetClient = chainId => {
  let client = Viem.Client.createPublicClient({
    "chain": Viem.Chains.chains->Js.Dict.unsafeGet("mainnet"),
    "transport": Viem.Transport.http(),
  })
  client
}

let client = createMainnetClient(1)

switch ReactDOM.querySelector("#root") {
| Some(domElement) =>
  ReactDOM.Client.createRoot(domElement)->ReactDOM.Client.Root.render(
    <React.StrictMode>
      <App />
      <Donate />
    </React.StrictMode>,
  )
| None => ()
}
