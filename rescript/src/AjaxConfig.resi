open AjaxParams
open WebTypes

type reqConfigPart
type reqConfigContainer

type reqConfig<'a> = {
  method: method,
  url: string,
  params: option<'a>,
  data: option<formData>,
}

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

let buildBaseUrlParam: string => reqConfigPart

let buildHeadersParam: array<(string, string)> => reqConfigPart

let buildTimeoutParam: int => reqConfigPart

let buildCredentialsParam: unit => reqConfigPart

let buildAuthParam: baseAuth => reqConfigPart

let buildResponseTypeParam: responseType => reqConfigPart

let buildXsrfCookieNameParam: string => reqConfigPart

let buildXsrfHeaderNameParam: string => reqConfigPart

let buildMaxContentLengthParam: int => reqConfigPart

let buildMaxBodyLengthParam: int => reqConfigPart

let buildProxyParam: proxyConfig => reqConfigPart

let buildDecompressParam: unit => reqConfigPart

let buildMaxRedirectsParam: int => reqConfigPart

let containerizereqConfig: (reqConfig<'a>, array<reqConfigPart>) => reqConfigContainer

let buildParamsContainer: (reqConfig<'p>, array<advAjaxParam>) => reqConfigContainer
