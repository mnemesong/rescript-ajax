open Belt
open AjaxData
open WebTypes

type reqParamPart
type reqParamsContainer

type reqParams<'a> = {
  method: method,
  url: string,
  params: option<{..} as 'a>,
  data: option<formData>,
}

type ajaxProtocol = [ #http | #https ]

type proxyParams = {
  protocol: ajaxProtocol,
  host: string,
  port: int,
  auth: baseAuth
}

type responseType = 
  [ #arraybuffer
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

let buildBaseUrlParam: (string) => reqParamPart = %raw(`function (baseUrl) {
    return { baseURL: baseUrl };
}`)

let buildHeadersParam: (array<(string, string)>) => reqParamPart = %raw(`function (headers) {
    const result = {};
    headers.forEach(h => {
        result[h[0]] = h[1];
    })
    return { headers: result };
}`)

let buildTimeoutParam: (int) => reqParamPart = %raw(`function (timeout) {
    return { timeout: timeout };
}`)

let buildCredentialsParam: () => reqParamPart = %raw(`function () {
    return { withCredentials: true };
}`)

let buildAuthParam: (baseAuth) => reqParamPart = %raw(`function(auth) {
    return { auth: auth };
}`)

let buildResponseTypeParam: (responseType) => reqParamPart = %raw(`function(resT) {
    return { responseType: resT };
}`)

let buildXsrfCookieNameParam: (string) => reqParamPart = %raw(`function (xsrfcn) {
    return { xsrfCookieName: xsrfcn };
}`)

let buildXsrfHeaderNameParam: (string) => reqParamPart = %raw(`function (xsrfhn) {
    return { xsrfHeaderName: xsrfhn };
}`)

let buildMaxContentLengthParam: (int) => reqParamPart = %raw(`function (mcl) {
    return { maxContentLength: mcl };
}`)

let buildMaxBodyLengthParam: (int) => reqParamPart = %raw(`function (mbl) {
    return { maxBodyLength: mbl };
}`)

let buildProxyParam: (proxyParams) => reqParamPart = %raw(`function (proxy) {
    return { proxy: proxy };
}`)

let buildDecompressParam: () => reqParamPart = %raw(`function () {
    return { decompress: true };
}`)

let buildMaxRedirectsParam: (int) => reqParamPart = %raw(`function (mr) {
    return { maxRedirects: mr };
}`)

let containerizeReqParams: (reqParams<{..}>, array<reqParamPart>) => reqParamsContainer =
%raw(`function (reqParams, reqParamParts) {
    const result = {...reqParams};
    reqParamParts.forEach(rp => {
        Object.keys(rp).forEach(k => {
            result[k] = rp[k];
        })
    })
    return result;
}`)

let buildParamsContainer = (
    reqParams: reqParams<{..}>,
    advAjaxParams: array<advAjaxParam>
): reqParamsContainer => {
    let reqParamsParts: array<reqParamPart> = advAjaxParams 
        -> Array.map((aap) => switch aap {
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
        })
    containerizeReqParams(reqParams, reqParamsParts)
}