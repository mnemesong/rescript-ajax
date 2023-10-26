open Belt

module type Data = {
  type data

  let parseData: unknown => result<data, string>
}

module type DataUnknown = Data with type data = unknown

module DataUnknown: DataUnknown = {
  type data = unknown

  let parseData: unknown => result<unknown, string> = r => Ok(r)
}

module type DataText = Data with type data = string

module DataText: DataText = {
  type data = string

  let parseData: unknown => result<string, string> = data =>
    try {
      let parser: unknown => string = %raw(`
      function (u) {
        if(typeof u !== 'string') {
          throw new Error("Response data is not a string");
        }
        return u;
      }
      `)
      Ok(parser(data))
    } catch {
    | Js.Exn.Error(e) => Error(e->Js.Exn.message->Option.getWithDefault(""))
    | _ => Error("Unknown error")
    }
}
