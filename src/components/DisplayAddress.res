// example: DisplayAddress.ellipsifyMiddle(
//         ~inputString="abcdefghijkarsartar",
//         ~precedingTrailingCharactersLength=4,
//       ) == "abcd...rtar"

let ellipsifyMiddle = (~inputString, ~precedingTrailingCharactersLength) => {
  let stringLength = inputString->String.length

  if stringLength > precedingTrailingCharactersLength * 2 {
    inputString->String.substring(~start=0, ~end=precedingTrailingCharactersLength) ++
    "..." ++
    inputString->String.substring(
      ~start=Js.Math.abs_int(stringLength - precedingTrailingCharactersLength),
      ~end=stringLength,
    )
  } else {
    inputString
  }
}
