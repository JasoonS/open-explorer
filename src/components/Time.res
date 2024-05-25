let useTypedCharactersString = (~delay=25, string) => {
  let (revealedCharCount, setRevealedCharCount) = React.useState(_ => 0)
  let (optIntervalId, setOptIntervalId) = React.useState(_ => None)

  React.useEffect4(() => {
    let _ = optIntervalId->Option.map(intervalId => {
      if revealedCharCount >= string->String.length {
        Js.Global.clearInterval(intervalId)
      }
    })

    None
  }, (optIntervalId, revealedCharCount, string, delay))

  React.useEffect2(() => {
    setRevealedCharCount(_ => 0)
    let intervalId = Js.Global.setInterval(() => {
      setRevealedCharCount(
        prevCount => {
          prevCount + 1
        },
      )
    }, delay)

    setOptIntervalId(_ => Some(intervalId))

    Some(() => Js.Global.clearInterval(intervalId))
  }, (delay, string))

  string->Js.String2.substrAtMost(~from=0, ~length=revealedCharCount)
}

let useRotatingCharacterAnimation = (~delay=25, string) => {
  let (index, setIndex) = React.useState(_ => 0)
  let (charToShow, setCharToShow) = React.useState(_ => string->String.charAt(index))
  let stringLength = string->String.length
  let (optIntervalId, setOptIntervalId) = React.useState(_ => None)

  React.useEffect2(() => {
    let intervalId = Js.Global.setInterval(() => {
      setIndex(
        index => {
          let inc = index + 1
          setCharToShow(_ => string->String.charAt(Int.mod(inc, stringLength)))
          inc
        },
      )
    }, delay)

    setOptIntervalId(_ => Some(intervalId))

    Some(() => Js.Global.clearInterval(intervalId))
  }, (delay, string))

  charToShow
}

@ocaml.doc(`Delay the display execution`)
module DelayedDisplay = {
  @react.component
  let make = (~delay=1000, ~children, ~tempDisplay=React.null) => {
    let (show, setShow) = React.useState(_ => false)

    React.useEffect1(() => {
      let timeout = Js.Global.setTimeout(_ => setShow(_ => true), delay)
      Some(_ => Js.Global.clearTimeout(timeout))
    }, [])

    if show {
      children
    } else {
      tempDisplay
    }
  }
}

@ocaml.doc(`Repeat the display execution`)
module RepeatDisplay = {
  @react.component
  let make = (~delay, ~children) => {
    let (show, setShow) = React.useState(_ => false)

    React.useEffect1(() => {
      let intervalId = Js.Global.setInterval(_ => setShow(_ => true), delay)
      let intervalIdForFlashRender = Js.Global.setInterval(_ => setShow(_ => false), delay + 100)
      Some(
        _ => {
          Js.Global.clearInterval(intervalId)
          Js.Global.clearInterval(intervalIdForFlashRender)
        },
      )
    }, [])

    if show {
      React.null
    } else {
      children
    }
  }
}

@ocaml.doc(`Delay the state setting`)
let useDelayedState = (~delay=1000, ~functionSetter, ~state) => {
  React.useEffect1(() => {
    let timeout = Js.Global.setTimeout(_ => functionSetter(_ => state), delay)
    Some(_ => Js.Global.clearTimeout(timeout))
  }, [])
}

@ocaml.doc(`Runs a callback on an interval predictably`)
let useInterval = (callback: unit => unit, ~delay) => {
  let savedCallback: React.ref<unit => unit> = React.useRef(callback)

  // Remember the latest callback so that is persists between renders
  React.useEffect1(() => {
    savedCallback.current = callback
    None
  }, [callback])

  // Set up the interval.
  React.useEffect1(() => {
    let id = Js.Global.setInterval(savedCallback.current, delay)
    Some(() => Js.Global.clearInterval(id))
  }, [delay])
}
