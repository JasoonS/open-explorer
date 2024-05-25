let schema: S.schema<bigint> =
  S.string
  ->S.setName("BigInt")
  ->S.transform(s => {
    parser: str =>
      switch BigInt.fromString(str) {
      | exception _exn => s.fail("The string is not valid bigint")
      | bigInt => bigInt
      },
    serializer: v => BigInt.toString(v),
  })
