module Address = {
  type t

  @module("viem") external fromStringUnsafe: string => t = "getAddress"

  let fromString = str =>
    switch fromStringUnsafe(str) {
    | exception exn => Error(exn)
    | addr => Ok(addr)
    }

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
