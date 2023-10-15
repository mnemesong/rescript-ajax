# rescript-ajax
lib for sending ajax on rescript


## Usage example
```rescript
open AjaxBrowser
open WebTypes
open AjaxData

let sendQuerySelectHtmlElem: string => option<Dom.htmlElement> = %raw(`
function (qs) { return document.querySelector(qs); }
`)

let sendGet = () => {
  switch sendQuerySelectHtmlElem("#getForm") {
  | None => Js.Console.log("Can't send data")
  | Some(htmlEl) => {
      let res =
        FormUrlencoded(#get, "/get")->AjaxBrowser.sendAjaxFormData(collectFormData(htmlEl), [])
          |> Js.Promise.then_(a => {
            Js.Promise.resolve()
          })
    }
  }
}

%%raw(`
document.getElementById("sendGetBtn").onclick = sendGet;
`)
```


## API

#### AjaxData.res
```rescript
type formData

let structToFormData: {..} => formData = ...

let formDataToStruct: formData => {..} = ...

let collectFormData: Dom.htmlElement => formData = ...

let mergeFormData: (formData, formData) => formData = ...
```

#### Ajaxparams.res
```rescript
type reqParamPart
type reqParamsContainer

type reqParams<'a> = {
  method: method,
  url: string,
  params: option<{..} as 'a>,
  data: option<formData>,
}

type ajaxProtocol = [#http | #https]

type proxyParams = {
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
  | AjaxProxy(proxyParams)
  | AjaxDecompress

type containerizeReqParams<'a> = (reqParams<{..} as 'a>, array<reqParamPart>) => reqParamsContainer

let containerizeReqParams: containerizeReqParams<{..}> = ...

let buildParamsContainer = (
  reqParams: reqParams<{..}>,
  advAjaxParams: array<advAjaxParam>,
): reqParamsContainer => ...
```

#### AjaxManager.res
```rescript
type axios
type url = string
type action =
  | FormUrlencoded(method, url)
  | MultipartFormData(method, url)

module type AjaxEnv = {
  let getAxios: unit => axios
}

module type AjaxManager = {
  let sendAjaxParams: (action, {..}, array<advAjaxParam>) => promise<{..}>
  let sendAjaxFormData: (action, formData, array<advAjaxParam>) => promise<{..}>
}

module type MakeAjaxManager = (AE: AjaxEnv) => AjaxManager

let sendAxios: (axios, reqParamsContainer) => promise<{..}> = ...
```

#### AjaxBrowser.res
```rescript
module AjaxEnvBrowser = {
  let getAxios: unit => axios = %raw(`
  function () { return require('axios/dist/browser/axios.cjs'); }
  `)
}

module AjaxBrowser = MakeAjaxManager(AjaxEnvBrowser)
```

#### AjaxNode.res
```rescript
module AjaxEnvNode = {
  let getAxios: unit => axios = %raw(`
  function() { return require('axios/dist/node/axios.cjs'); }
  `)
}

module AjaxNode = MakeAjaxManager(AjaxEnvNode)
```


## License
MIT


## Author
Anatoly Starodubtsev
tostar74@mail.ru