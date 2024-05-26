type response<'a> = Loading | Err(exn) | Data('a)

let getServerUrl = (~chainId) => `https://${chainId->Int.toString}.hypersync.xyz`

let useChainHeight = (~chainId) => {
  let (height, setHeight) = React.useState(_ => Loading)

  React.useEffect1(() => {
    let serverUrl = getServerUrl(~chainId)
    setHeight(_ => Loading)
    let pollHeight = () =>
      HyperSyncJsonApi.getArchiveHeight(~serverUrl)
      ->Promise.thenResolve(res => {
        setHeight(
          prev =>
            switch (prev, res) {
            | (Data(prevHeight), Ok(h)) if h > prevHeight => Data(h)
            | (Data(_), _) => prev
            | (_, Ok(h)) => Data(h)
            | (_, Error(err)) => Err(err)
            },
        )
      })
      ->Promise.catch(exn => {
        Console.log(exn)
        setHeight(
          prev =>
            switch prev {
            | Data(h) => Data(h)
            | _ => Err(exn)
            },
        )

        Promise.resolve()
      })
      ->ignore

    pollHeight()

    let intervalId = setInterval(() => {
      pollHeight()
    }, 1000)

    Some(
      () => {
        intervalId->clearInterval
      },
    )
  }, [chainId])

  height
}

let useBlocks = (~chainId, ~chainHeight, ~pageSize=20, ~pageIndex=0) => {
  let (blocks, setBlocks) = React.useState(_ => Loading)
  let (isLoading, setIsLoading) = React.useState(() => false) // used for refetch loading without clearing the page

  React.useEffect4(() => {
    let serverUrl = getServerUrl(~chainId)
    let toBlock = chainHeight - pageSize * pageIndex
    let fromBlock = toBlock - pageSize + 1
    Queries.Blocks.getBlocks(~serverUrl, ~fromBlock, ~toBlock)
    ->Promise.thenResolve(res => {
      setBlocks(_ => Data(res->Array.toReversed))
      setIsLoading(_ => false)
    })
    ->Promise.catch(exn => {
      Console.error(exn)
      setBlocks(
        prev =>
          switch prev {
          | Data(h) => Data(h)
          | _ => Err(exn)
          },
      )
      setIsLoading(_ => false)
      Promise.resolve()
    })
    ->ignore

    None
  }, (chainId, chainHeight, pageSize, pageIndex))

  (blocks, isLoading)
}

let useBlock = (~chainId, ~blockNumber) => {
  let blocks = useBlocks(~chainId, ~chainHeight=blockNumber, ~pageSize=1)

  switch blocks {
  | (Data(blocks), false) => Data(blocks[0])
  | (Err(err), _) => Err(err)
  | (_, true) | (Loading, false) => Loading
  }
}

let useTransaction = (~chainId, ~txHash, ~rpcUrl) => {
  let (tx, setTx) = React.useState(_ => Loading)

  React.useEffect3(() => {
    Queries.Transaction.getTransaction(~chainId, ~txHash, ~rpcUrl)
    ->Promise.thenResolve(res => {
      switch res {
      | Ok(txData) => setTx(_ => Data(txData))
      | Error(exn) =>
        Console.error(exn)
        setTx(
          prev =>
            switch prev {
            | Data(txData) => Data(txData)
            | _ => Err(exn)
            },
        )
      }
    })
    ->ignore

    None
  }, (chainId, txHash, rpcUrl))

  tx
}
