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

open Fetch

type ensDataResp = {ens: string}

// todo, having cors issues with
let tryUseEnsHandle = async address => {
  try {
    let resp = await fetch(
      `https://ensdata.net/${address}`,
      {
        method: #GET,
        headers: Headers.fromObject({
          "Content-type": "application/json",
        }),
      },
    )
    Js.Console.log(resp)
    if Response.ok(resp) {
      let ens: ensDataResp = await Response.json(resp)->Obj.magic
      ens.ens
    } else {
      address
    }
  } catch {
  | _ => address
  }
}

@react.component
let make = (~address) => {
  let (displayAddress, setDisplayAddress) = React.useState(() => address)

  React.useEffect1(() => {
    let _ = tryUseEnsHandle(displayAddress)->Promise.then(ensData => {
      setDisplayAddress(_ => ensData)
      None->Promise.resolve
    })
    None
  }, [address])

  displayAddress->React.string
}
