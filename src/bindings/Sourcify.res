// TODO: add decoding of the response.

let rootDomain = "https://sourcify.dev/server"

module VerifyEtherscan = {
  let endpoint = rootDomain ++ "/verify/etherscan"

  type requestBody = {
    address: string,
    chainId: string,
    apiKey?: string,
  }

  type responseItem = {
    address: string,
    chainId: string,
    status: string,
    message: option<string>,
    libraryMap: Js.Dict.t<string>,
  }

  type response = {result: array<responseItem>}

  let verify = async (data: requestBody) => {
    open Fetch

    let response = await fetch(
      endpoint,
      {
        method: #POST,
        body: data->Js.Json.stringifyAny->Belt.Option.getExn->Body.string,
        headers: Headers.fromObject({
          "Content-type": "application/json",
        }),
      },
    )

    await response->Response.json
  }
}

module CheckByAddresses = {
  let endpoint = rootDomain ++ "/check-by-addresses"

  type responseChain = {
    chainId: string,
    status: string,
  }

  type responseItem = {
    address: string,
    chainIds: array<string>,
    status: option<string>,
  }

  type response = array<responseItem>

  let check = async (addresses: string, chainIds: string) => {
    open Fetch

    let queryParams = `?addresses=${addresses}&chainIds=${chainIds}`
    let response = await Fetch.get(endpoint ++ queryParams)
    await response->Fetch.Response.json
  }
}

module FilesByAddress = {
  let endpoint = rootDomain ++ "/files"

  type fileItem = {
    name: string,
    path: string,
    content: string,
  }

  type response = array<fileItem>

  let getFiles = async (chain: string, address: string): response => {
    open Fetch

    let url = endpoint ++ `/${chain}/${address}`
    let response = await Fetch.get(url)
    await response->Obj.magic
  }
}

module Examples = {
  let testVerifyEtherscan = async () => {
    let data: VerifyEtherscan.requestBody = {
      address: "0x67c349467D639A9e0822c079Aee8DF9964308BC9",
      chainId: "137",
    }

    let response = await VerifyEtherscan.verify(data)
    Js.log(response)
  }

  let testCheckByAddresses = async () => {
    let addresses = "0x67c349467D639A9e0822c079Aee8DF9964308BC9"
    let chainIds = "137"

    let response = await CheckByAddresses.check(addresses, chainIds)
    Js.log(response)
  }

  let testFilesByAddress = async () => {
    let chain = "137"
    let address = "0x67c349467D639A9e0822c079Aee8DF9964308BC9"

    let response = await FilesByAddress.getFiles(chain, address)
    // Js.log2("files by address", response->Array.map(item => item.name))
    Js.log2("files by address", response)
  }
  //
  await testVerifyEtherscan()
  // await testCheckByAddresses()
  await testFilesByAddress()
}
