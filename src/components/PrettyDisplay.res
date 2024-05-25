module TextUserInput = {
  @react.component
  let make = (~userInput) => {
    let delay = 100
    let typedInput = Time.useTypedCharactersString(~delay, userInput)
    let totalTime = delay * userInput->String.length + delay * 2 // the total time for the text to type + an extra pause at the end
    let (answered, setAnswered) = React.useState(_ => false)
    Time.useDelayedState(~delay=totalTime, ~functionSetter=setAnswered, ~state=true)

    <span>
      {typedInput->React.string}
      // terminal style cursor
      {answered
        ? React.null
        : <span className="ml-1 w-1 h-full bg-white opacity-30"> {"_"->React.string} </span>}
    </span>
  }
}

module QuestionTyped = {
  @react.component
  let make = (~prompt, ~answer, ~timeTillAnswered=1000) => {
    let (answered, setAnswered) = React.useState(_ => false)
    Time.useDelayedState(~delay=timeTillAnswered, ~functionSetter=setAnswered, ~state=true)
    <p>
      <span className="text-green-500"> {(answered ? ">" : "?")->React.string} </span>
      {(" " ++ prompt ++ ": ")->React.string}
      <Time.DelayedDisplay delay=500>
        <span className={answered ? "text-blue-500" : ""}>
          <TextUserInput userInput=answer />
        </span>
      </Time.DelayedDisplay>
    </p>
  }
}
