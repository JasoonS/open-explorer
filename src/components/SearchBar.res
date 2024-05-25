type searchType = Account | TxHash | EnsHandle | Block | Unknown(string)

let searchTypeToString = (searchType: searchType): string =>
  switch searchType {
  | Account => "Account"
  | TxHash => "TxHash"
  | EnsHandle => "EnsHandle"
  | Block => "Block"
  | Unknown(_) => "Unknown"
  }

let searchTypeToRoute = (searchType: searchType): string =>
  switch searchType {
  | Account => "address"
  | TxHash => "tx"
  | EnsHandle => "address"
  | Block => "block"
  | Unknown(_) => "Unknown"
  }

// this algorithm can definitely be improved but for now this is good enough
let predictSearchType = (search: string): searchType => {
  // if the string can be parsed as number we presume its a block
  // else if it doesn't start with an 0x we presume its an ens handle
  // else if it is longer than an account we presume its a tx hash
  // else its an account

  if search->Int.fromString->Option.isSome {
    Block
  } else if !(search->String.startsWith("0x")) {
    EnsHandle
  } else if search->String.length == 66 {
    TxHash
  } else if search->String.length == 42 {
    Account
  } else {
    Unknown("This doesn't match any known search type")
  }
}

@react.component
let make = () => {
  let (inputValue, setInputValue) = React.useState(() => "")
  let (errorMessage, setErrorMessage) = React.useState(() => "") // todo make opt and handle properly
  let url = RescriptReactRouter.useUrl()

  let handleKeyPress = event => {
    if event->ReactEvent.Keyboard.key === "Enter" {
      let searchType = predictSearchType(inputValue)

      switch searchType {
      | Unknown(e) => setErrorMessage(_ => e)
      | EnsHandle =>
        // this is only applicable if the user has entered an ens handle
        inputValue
        ->ENSDataCustomFetch.tryResolveEnsHandle
        ->Promise.thenResolve(address => {
          RescriptReactRouter.push(
            `/${url.path
              ->List.head
              ->Option.getOr("unknown")}/${searchType->searchTypeToRoute}/${address}`,
          )
        })
        ->Promise.catch(exn => {
          Console.log(exn)
          setErrorMessage(_ => "unable to resolve ens handle")
          Promise.resolve()
        })
        ->ignore
      | _ =>
        //  this is only applicable if the user has entered an ens handle
        RescriptReactRouter.push(
          `/${url.path
            ->List.head
            ->Option.getOr("unknown")}/${searchType->searchTypeToRoute}/${inputValue}`,
        )
      }
    }
  }

  <div className="flex flex-col justify-center w-full m-10">
    <div className="flex flex-row justify-center">
      <div
        className="flex flex-row mt-1 block w-full max-w-[700px] px-3 py-2 border border-primary border-1 bg-white bg-opacity-80 shadow text-sm">
        <input
          type_="text"
          placeholder="Account | Tx hash | Ens handle | Block "
          onKeyPress={handleKeyPress}
          onChange={e => {
            ReactEvent.Form.preventDefault(e)
            setInputValue(JsxEventU.Form.target(e)["value"])
          }}
        />
        <div className="min-w-[200px] text-right"> {"⏎ Enter to 🔍"->React.string} </div>
      </div>
    </div>
    <div className="text-xxs text-left text-yellow-300 text-center">
      {errorMessage->React.string}
    </div>
  </div>
}
