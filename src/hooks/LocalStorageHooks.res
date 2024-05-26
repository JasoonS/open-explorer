let useLocalStorageStateAtKey = (~key) => {
  let (state, setState) = React.useState(_ => None)

  React.useEffect0(() => {
    let item = Dom.Storage2.localStorage->Dom.Storage2.getItem(key)
    setState(_ => item)

    None
  })

  let setStorage = item => {
    Js.log("Setting storage" ++ item)
    Dom.Storage2.localStorage->Dom.Storage2.setItem(key, item)
    setState(_ => Some(item))
  }

  (state, setStorage)
}

let useLocalRpcStorage = () => {
  let key = "rpc"
  let (localRpc, setLocalRpc) = useLocalStorageStateAtKey(~key)
  (localRpc, setLocalRpc)
}

let useDataSourceStorage = () => {
  let key = "source"
  let (dataSource, setDataSource) = useLocalStorageStateAtKey(~key)
  (dataSource->Option.getOr("HyperSync")->DataSource.stringToDataSource, setDataSource)
}
