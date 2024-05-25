module Chains = {
  type chain

  @module external chains: Js.Dict.t<chain> = "viem/chains"

  let fromChainId = (chainId: int): option<chain> =>
    try {
      let viemChainName = Constants.idToViemName->Js.Dict.get(chainId->Int.toString)
      switch viemChainName {
      | None => Js.Exn.raiseError("Unable to map chainId to viem chain")
      | Some(viemChain) => chains->Js.Dict.get(viemChain)
      }
    } catch {
    | _ => Js.Exn.raiseError("Unable to map chainId to viem chain")
    }
}

module Transport = {
  type t
  @module("viem") external http: unit => t = "http"
}

type address
module Client = {
  type t

  @module("viem")
  external createPublicClient: {"chain": Chains.chain, "transport": Transport.t} => t =
    "createPublicClient"

  @send external getBalance: (t, {"address": address}) => promise<bigint> = "getBalance"
}

module Address = {
  type t = address

  @module("viem") external fromStringUnsafe: string => t = "getAddress"

  let fromString = str =>
    switch fromStringUnsafe(str) {
    | exception exn => Error(exn)
    | addr => Ok(addr)
    }

  let zeroAddress = "0x0000000000000000000000000000000000000000"->fromStringUnsafe

  let toString = (addr: t): string => Obj.magic(addr)

  let schema = S.string->S.transform(s => {
    parser: str =>
      switch fromString(str) {
      | Ok(addr) => addr
      | Error(_) => s.fail("Invalid address")
      },
    serializer: toString,
  })
}

module Topic = {
  type t
  let fromString = (str: string): t => Obj.magic(str)
  let toString = (addr: t): string => Obj.magic(addr)
  let schema: S.schema<t> = Obj.magic(S.string)
}

module Utilities = {
  module Units = {
    @module("viem") external formatEther: bigint => int = "formatEther"
  }
}
