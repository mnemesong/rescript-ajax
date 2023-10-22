# rescript-ajax
lib for sending ajax on rescript


## Usage example
```rescript
open AjaxBrowser
open AjaxParams

let sendQuerySelectHtmlElem: string => option<Dom.htmlElement> = %raw(`
function (qs) {
  return document.querySelector(qs);
}
`)
@@warning("-26")

let sendGet = async () => {
  switch sendQuerySelectHtmlElem("#getForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) => {
      let res =
        await FormUrlencoded(#get, "/get")->AjaxBrowserUnknown.sendAjaxFormData(
          collectFormData(htmlEl),
          [],
        )
      Js.Console.log(res)
    }
  }
}

@@warning("+26")
%%raw(`
document.getElementById("sendGetBtn").onclick = sendGet;
`)
```


## API

#### AjaxParams.resi
Module contains functions for working with params and formData
```rescript
type formData

//Collect params object to formData
let structToFormData: 'p => formData

//Convert formData to js structure
let formDataToStruct: formData => {..}

let collectFormData: Dom.htmlElement => formData

let mergeFormData: (formData, formData) => formData
```

#### AjaxConfig.resi
Module contains functions and types for configurating extra request params
```rescript
open AjaxParams
open WebTypes

type ajaxProtocol = [#http | #https]

type proxyConfig = {
  protocol: ajaxProtocol,
  host: string,
  port: int,
  auth: baseAuth,
}

type responseType = [
  | #arraybuffer
  | #document
  | #json
  | #text
  | #stream
  | #blob
]

type advAjaxParam =
  | AjaxBaseUrl(string)
  | AjaxHeaders(array<(string, string)>)
  | AjaxTimeout(int)
  | AjaxWithCredentials
  | AjaxAuth(baseAuth)
  | AjaxResponseType(responseType)
  | AjaxXsrfCookieName(string)
  | AjaxXsrfHeaderName(string)
  | AjaxMaxContentLength(int)
  | AjaxMaxBodyLength(int)
  | AjaxMaxRedirects(int)
  | AjaxProxy(proxyConfig)
  | AjaxDecompress
```

#### AjaxData.resi
Module contains abstractions for building Data module, which will use for response-data validation in AjaxManager. Also contains prepared DataUnknown and DataText modules
```rescript
module type Data = {
  type data
  let parseData: unknown => result<data, string>
}

module type DataUnknown = Data with type data = unknown
module DataUnknown: DataUnknown

module type DataText = Data with type data = string
module DataText: DataText
```

#### AjaxManager.resi
Module contains AjaxManager abstraction for module, thats contains api for sending AJAX. Also contains MakeAjaxManager functor, thats allows to configure environment and data-parser for AjaxManager module.
```rescript
open AjaxData
open AjaxParams
open WebTypes
open AjaxConfig

type axios
type url = string
type action =
  | FormUrlencoded(method, url)
  | MultipartFormData(method, url)

type ajaxResponse<'d> = {
  data: 'd,
  status: int,
  headers: unknown,
}

module type AjaxEnv = {
  let getAxios: unit => axios
}

module type AjaxManager = {
  type data

  let sendAjaxParams: (action, 'p, array<advAjaxParam>) => promise<ajaxResponse<data>>
  let sendAjaxFormData: (action, formData, array<advAjaxParam>) => promise<ajaxResponse<data>>
}

module type MakeAjaxManager = (AE: AjaxEnv, Data: Data) => (AjaxManager with type data = Data.data)
module MakeAjaxManager: MakeAjaxManager
```

#### AjaxNode.resi
AjaxManager reslizations for Node.js
```rescript
open AjaxManager

module AjaxEnvNode: AjaxEnv

module type AjaxNode = (Data: AjaxData.Data) => (AjaxManager with type data = Data.data)
module AjaxNode: AjaxNode

module type AjaxNodeUnknown = AjaxManager with type data = unknown
module AjaxNodeUnknown: AjaxNodeUnknown

module type AjaxNodeText = AjaxManager with type data = string
module AjaxNodeText: AjaxNodeText
```

#### AjaxBrowser.resi
AjaxManager reslizations for Browser
```rescript
open AjaxManager

module AjaxEnvBrowser: AjaxEnv

module type AjaxBrowser = (Data: AjaxData.Data) => (AjaxManager with type data = Data.data)
module AjaxBrowser: AjaxBrowser

module type AjaxBrowserUnknown = AjaxManager with type data = unknown
module AjaxBrowserUnknown: AjaxBrowserUnknown

module type AjaxBrowserText = AjaxManager with type data = string
module AjaxBrowserText: AjaxBrowserText

```


## License
MIT


## Author
Anatoly Starodubtsev
tostar74@mail.ru