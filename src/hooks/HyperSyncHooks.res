type response<'a> = Loading | Err(exn) | Data('a)

let useChainHeight = (~serverUrl) => {
  let (height, setHeight) = React.useState(_ => Loading)

  React.useEffect1(() => {
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
  }, [serverUrl])

  height
}

let useBlocks = (~serverUrl, ~chainHeight, ~pageSize=20, ~pageIndex=0) => {
  let (blocks, setBlocks) = React.useState(_ => Loading)

  React.useEffect3(() => {
    let toBlock = chainHeight - pageSize * pageIndex
    let fromBlock = toBlock - pageSize + 1
    Queries.getBlocks(~serverUrl, ~fromBlock, ~toBlock)
    ->Promise.thenResolve(res => {
      setBlocks(_ => Data(res->Array.toReversed))
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

      Promise.resolve()
    })
    ->ignore

    None
  }, (serverUrl, chainHeight, pageSize))

  blocks
}
