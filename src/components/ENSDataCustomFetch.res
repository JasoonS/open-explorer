// this code uses the public free ens api https://ensdata.net/

// example query & response

//curl GET https://ensdata.net/0xd55Ab78034FcB6349830d0CfdFEFB6A8051d2685

// {
//   "address": "0xd55Ab78034FcB6349830d0CfdFEFB6A8051d2685",
//   "avatar": "https://loch.ie/pic.jpg",
//   "avatar_small": "https://ensdata.net/media/avatar/lochie.eth",
//   "avatar_url": "https://loch.ie/pic.jpg",
//   "contentHash": null,
//   "description": "it's pronounced 🔐",
//   "discord": "lochie#4987",
//   "ens": "lochie.eth",
//   "ens_primary": "lochie.eth",
//   "github": "lochie",
//   "keywords": "lochie",
//   "notice": "me senpai ✨",
//   "resolverAddress": "0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41",
//   "twitter": "lochieaxon",
//   "url": "https://loch.ie",
//   "wallets": {
//     "eth": "0xd55Ab78034FcB6349830d0CfdFEFB6A8051d2685"
//   }
// }

// note api often doesn't return all fields

type ensDataResp = {ens: string, address: string}
type vague
type response = {status: int, json: vague}
@val external fetch: string => promise<response> = "fetch"
@send external json: response => promise<'a> = "json"

// let makeRequest = async url => {
//   let response = await fetch(url)
//   let json = await response->json
//   Js.log(json)
// }

// todo, having cors issues with, also make this more related to resolvind ens handles
let tryResolveEnsHandle = async ensHandle => {
  try {
    let resp = await fetch(`https://ensdata.net/${ensHandle}`)
    Js.log(resp)
    let json = await resp->json
    if json.status == 200 {
      json.address
    } else {
      Js.Exn.raiseError("Unable to resolve ens handle")
    }
  } catch {
  | _ => Js.Exn.raiseError("Unable to resolve ens handle")
  }
}

@react.component
let make = (~address) => {
  let (displayAddress, setDisplayAddress) = React.useState(() => address)

  React.useEffect1(() => {
    let _ = tryResolveEnsHandle(displayAddress)->Promise.then(ensData => {
      setDisplayAddress(_ => ensData)
      None->Promise.resolve
    })
    None
  }, [address])

  displayAddress->React.string
}
