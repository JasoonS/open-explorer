type ellipsisSize = Medium | Small

@module
external ellipsesLoaderStyles: {
  "ellipsis": string,
  "ellipsis-inner": string,
  "ellipsis-small": string,
} = "../styles/ellipsis-loader.module.css"

module Pepe = {
  @react.component
  let make = () => {
    let visualOffsetStyle = "translate-x-1"
    <div>
      <div className={"relative w-14 h-14 mx-auto"}>
        <img
          src={"https://media-float-capital.fra1.cdn.digitaloceanspaces.com/public/envio/app/pepe-dancing-transparent.gif"}
          alt="Pepe dancing"
          width={"56px"}
          height={"56px"}
        />
      </div>
      <div className={ellipsesLoaderStyles["ellipsis"] ++ " " ++ visualOffsetStyle}>
        <div className={ellipsesLoaderStyles["ellipsis-inner"]} />
      </div>
    </div>
  }
}

module Ellipses = {
  @react.component
  let make = (~size: ellipsisSize=Medium) =>
    <div className="relative">
      <div
        className={ellipsesLoaderStyles["ellipsis"] ++
        switch size {
        | Small => " " ++ ellipsesLoaderStyles["ellipsis-small"]
        | Medium => ""
        }}>
        <div className={ellipsesLoaderStyles["ellipsis-inner"]} />
      </div>
    </div>
}

module Tiny = {
  @react.component
  let make = () => {
    let (inlineLoaderState, setInlineLoaderState) = React.useState(_ => 0)

    Time.useInterval(() => setInlineLoaderState(current => mod(current + 1, 3)), ~delay=300)

    let elipsisDot = (~hide) =>
      <span className={hide ? "opacity-10" : "opacity-100"}> {`.`->React.string} </span>
    <div>
      {elipsisDot(~hide=inlineLoaderState == 0)}
      {elipsisDot(~hide=inlineLoaderState == 1)}
      {elipsisDot(~hide=inlineLoaderState == 2)}
    </div>
  }
}

let default = () => <Ellipses />
