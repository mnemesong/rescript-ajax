open AjaxParams
open WebTypes

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

let buildParamsContainer: (reqConfig<'p>, array<advAjaxParam>) => reqConfigContainer
