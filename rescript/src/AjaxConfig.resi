type reqConfigPart
type reqConfigContainer

type reqConfig<'a> = {
  method: WebTypes.method,
  url: string,
  params: option<{..} as 'a>,
  data: option<AjaxParams.formData>,
}

type ajaxProtocol = [#http | #https]

type proxyConfig = {
  protocol: ajaxProtocol,
  host: string,
  port: int,
  auth: WebTypes.baseAuth,
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
  | AjaxAuth(WebTypes.baseAuth)
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

let buildAuthParam: WebTypes.baseAuth => reqConfigPart

let buildResponseTypeParam: responseType => reqConfigPart

let buildXsrfCookieNameParam: string => reqConfigPart

let buildXsrfHeaderNameParam: string => reqConfigPart

let buildMaxContentLengthParam: int => reqConfigPart

let buildMaxBodyLengthParam: int => reqConfigPart

let buildProxyParam: proxyConfig => reqConfigPart

let buildDecompressParam: unit => reqConfigPart

let buildMaxRedirectsParam: int => reqConfigPart

type containerizereqConfig<'a> = (reqConfig<{..} as 'a>, array<reqConfigPart>) => reqConfigContainer

let containerizereqConfig: containerizereqConfig<{..}>

let buildParamsContainer: (reqConfig<{..}>, array<advAjaxParam>) => reqConfigContainer
