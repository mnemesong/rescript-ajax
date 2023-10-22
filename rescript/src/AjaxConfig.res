open Belt
open AjaxParams
open WebTypes

type reqConfigPart
type reqConfigContainer

type reqConfig<'a> = {
  method: method,
  url: string,
  params: option<{..} as 'a>,
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

let buildBaseUrlParam: string => reqConfigPart = %raw(`
function (baseUrl) {
  return { baseURL: baseUrl };
}
`)

let buildHeadersParam: array<(string, string)> => reqConfigPart = %raw(`
function (headers) {
  const result = {};
  headers.forEach(h => {
    result[h[0]] = h[1];
  })
  return { headers: result };
}
`)

let buildTimeoutParam: int => reqConfigPart = %raw(`
function (timeout) {
  return { timeout: timeout };
}
`)

let buildCredentialsParam: unit => reqConfigPart = %raw(`
function () {
  return { withCredentials: true };
}
`)

let buildAuthParam: baseAuth => reqConfigPart = %raw(`
function(auth) {
  return { auth: auth };
}
`)

let buildResponseTypeParam: responseType => reqConfigPart = %raw(`
function(resT) {
  return { responseType: resT };
}
`)

let buildXsrfCookieNameParam: string => reqConfigPart = %raw(`
function (xsrfcn) {
  return { xsrfCookieName: xsrfcn };
}
`)

let buildXsrfHeaderNameParam: string => reqConfigPart = %raw(`
function (xsrfhn) {
  return { xsrfHeaderName: xsrfhn };
}
`)

let buildMaxContentLengthParam: int => reqConfigPart = %raw(`
function (mcl) {
  return { maxContentLength: mcl };
}
`)

let buildMaxBodyLengthParam: int => reqConfigPart = %raw(`
function (mbl) {
  return { maxBodyLength: mbl };
}
`)

let buildProxyParam: proxyConfig => reqConfigPart = %raw(`
function (proxy) {
  return { proxy: proxy };
}
`)

let buildDecompressParam: unit => reqConfigPart = %raw(`
function () {
  return { decompress: true };
}
`)

let buildMaxRedirectsParam: int => reqConfigPart = %raw(`
function (mr) {
  return { maxRedirects: mr };
}
`)

type containerizereqConfig<'a> = (reqConfig<{..} as 'a>, array<reqConfigPart>) => reqConfigContainer

let containerizereqConfig: containerizereqConfig<{..}> = %raw(`
function (reqConfig, reqConfigParts) {
  const result = {...reqConfig};
  reqConfigParts.forEach(rp => {
    Object.keys(rp).forEach(k => {
      result[k] = rp[k];
    })
  })
  return result;
}
`)

let buildParamsContainer = (
  reqConfig: reqConfig<{..}>,
  advAjaxParams: array<advAjaxParam>,
): reqConfigContainer => {
  let reqConfigParts: array<reqConfigPart> = advAjaxParams->Array.map(aap =>
    switch aap {
    | AjaxBaseUrl(url) => buildBaseUrlParam(url)
    | AjaxHeaders(headers) => buildHeadersParam(headers)
    | AjaxTimeout(timeout) => buildTimeoutParam(timeout)
    | AjaxWithCredentials => buildCredentialsParam()
    | AjaxAuth(auth) => buildAuthParam(auth)
    | AjaxResponseType(res) => buildResponseTypeParam(res)
    | AjaxXsrfCookieName(cn) => buildXsrfCookieNameParam(cn)
    | AjaxXsrfHeaderName(hn) => buildXsrfHeaderNameParam(hn)
    | AjaxMaxContentLength(len) => buildMaxContentLengthParam(len)
    | AjaxMaxBodyLength(len) => buildMaxBodyLengthParam(len)
    | AjaxMaxRedirects(cnt) => buildMaxRedirectsParam(cnt)
    | AjaxProxy(params) => buildProxyParam(params)
    | AjaxDecompress => buildDecompressParam()
    }
  )
  containerizereqConfig(reqConfig, reqConfigParts)
}
