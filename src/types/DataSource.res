type t = Rpc | HyperSync | EthArchive | Firehose

let dataSourceToString = (dataSource: t) =>
  switch dataSource {
  | Rpc => "Rpc"
  | HyperSync => "HyperSync"
  | EthArchive => "EthArchive"
  | Firehose => "Firehose"
  }

let stringToDataSource = (dataSource: string) =>
  switch dataSource {
  | "Rpc" => Rpc
  | "HyperSync" => HyperSync
  | "EthArchive" => EthArchive
  | "Firehose" => Firehose
  | _ => Rpc
  }
