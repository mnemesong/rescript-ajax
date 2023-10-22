module type Data = {
  type data

  let parseData: unknown => result<data, string>
}

module type DataUnknown = Data with type data = unknown

module DataUnknown: DataUnknown

module type DataText = Data with type data = string

module DataText: DataText
