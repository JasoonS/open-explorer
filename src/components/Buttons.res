@react.component
let make = (~text: string, ~onClick: unit => unit) => {
  <button
    className="bg-black px-4 py-1 m-2 text-primary border-primary border w-40 hover:bg-primary hover:text-black hover:border-2"
    onClick={_ => onClick()}>
    {text->React.string}
  </button>
}
