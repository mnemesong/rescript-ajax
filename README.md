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
  | Some(htmlEl) =>
    (await FormUrlencoded(#get, "/get")
    ->AjaxBrowser.sendAjaxFormData(collectFormData(htmlEl), [])
    ->ResultExn.thenTryMap(res => Js.Console.log(res.data))) //ResultExn - it's dev-dependency
    ->ResultExn.getExn
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

#### AjaxManager.resi
Module contains AjaxManager abstraction for module, thats contains api for sending AJAX. Also contains MakeAjaxManager functor, thats allows to configure environment and data-parser for AjaxManager module.
```rescript
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
  let sendAjaxParams: (
    action,
    'p,
    array<advAjaxParam>,
  ) => promise<result<ajaxResponse<unknown>, exn>>
  let sendAjaxFormData: (
    action,
    formData,
    array<advAjaxParam>,
  ) => promise<result<ajaxResponse<unknown>, exn>>
}

module type MakeAjaxManager = (AE: AjaxEnv) => AjaxManager
module MakeAjaxManager: MakeAjaxManager
```

#### AjaxNode.resi
AjaxManager reslizations for Node.js
```rescript
open AjaxManager

module AjaxEnvNode: AjaxEnv

module AjaxNode: AjaxManager
```

#### AjaxBrowser.resi
AjaxManager reslizations for Browser
```rescript
open AjaxManager

module AjaxEnvBrowser: AjaxEnv

module AjaxBrowser: AjaxManager

```


## License
MIT


## Author
Anatoly Starodubtsev
tostar74@mail.ru