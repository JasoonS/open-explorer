@react.component
let make = (~textToCopy, ~className="") => {
  <button
    onClick={_ => Navigator.copyToClipboard(textToCopy)}
    className={`px-[5px] py-[4px] mx-[5px] hover:bg-white active:bg-black ${className}`}>
    {`📋`->React.string}
  </button>
}
